from concurrent import futures
import argparse
import urllib.request
import json

import grpc
import users.v1.users_pb2 as users_pb2
import users.v1.users_pb2_grpc as users_pb2_grpc

def get_random_user():
    with urllib.request.urlopen("https://randomuser.me/api") as r:
        userdata = json.loads(r.read())
        namedata = userdata["results"][0]["name"]
        return "{} {}".format(namedata["first"], namedata["last"])


class Users(users_pb2_grpc.UserServiceServicer):
    def __init__(self):
        self.users = []

    def AddUser(self, request, context):
        new_id = get_random_user()
        self.users.append(new_id)
        return users_pb2.AddUserResponse(user=users_pb2.User(id=new_id))

    def ListUsers(self, request, context):
        for user in self.users:
            yield users_pb2.ListUsersResponse(user=users_pb2.User(id=user))


def serve(port):
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    users_pb2_grpc.add_UserServiceServicer_to_server(Users(), server)
    server.add_insecure_port("[::]:{}".format(port))
    server.start()
    print("Listening on {}".format(port))
    server.wait_for_termination()

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("port")
    args = parser.parse_args()
    serve(args.port)
