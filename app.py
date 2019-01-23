from flask import Flask
from flask_restful import Api, Resource, reqparse

app = Flask(__name__)
api = Api(app)

users = [
	{
		"name": "ben",
		"age": 20
	},
	{
		"name": "dover",
		"age": 19
	},
	{
		"name": "ulrich",
		"age": 21
	}
]

class User(Resource):
	def get(self, name):
		for user in users:
			if user['name'] == name:
				return user, 200
		return 'User not found', 404

	def post(self, name):
		parser = reqparse.RequestParser()
		print("0")
		parser.add_argument('age')
		print("1")
		args = parser.parse_args()
		print("2")
		for user in users:
			if user['name'] == name:
				return 'User already exists', 400

		user = {
			'name': name,
			'age': args['age']
		}
		users.append(user)
		return user, 201


	def put(self, name):
		parser = reqparse.RequestParser()
		parser.add_argument('age')
		args = parser.parse_args()
		for user in users:
			if user['name'] == name:
				user['age'] = args['age']
				return user, 200
		user = {
			'name': name,
			'age': args["age"]
			}
		users.append(user)
		return user, 201

	def delete(self, name):
		global users
		users = [user for user in users if user['name'] != name]
		return name + " is deleted", 200

api.add_resource(User, "/user/<string:name>")
app.run(debug=True)






