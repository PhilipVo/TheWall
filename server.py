from __future__ import print_function # In python 2.7
from flask import Flask, request, redirect, render_template, flash, session
from mysqlconnection import MySQLConnector
from flask.ext.bcrypt import Bcrypt
import sys, re

EMAIL_REGEX = re.compile(r'^[a-zA-Z0-9.+_-]+@[a-zA-Z0-9._-]+\.[a-zA-Z]+$')

app = Flask(__name__)
app.secret_key = 'SecretKey'
bcrypt = Bcrypt(app)
mysql = MySQLConnector(app,'walldb')

@app.route('/')
def index():
	# If active session:
	if session.get('user_id'):
		return redirect('/wall')
	return render_template('index.html')

@app.route('/login', methods=['POST'])
def login():
	data = 	{	'email': request.form.get('email'),
				'password': request.form.get('password')
			}

	# Check if login fields are empty:				
	for key, value in data.iteritems():
		if len(value) == 0:
			flash('red')
			flash('Login failed: email/password cannot be empty.')
			return redirect('/')

	query = """SELECT * FROM users
				WHERE email = :email LIMIT 1
			"""		
	user = mysql.query_db(query, data)

	# If registered email found:
	if len(user) != 0:
		# Check if password is correct:
		if bcrypt.check_password_hash(user[0]['password'], data['password']):
			session['user_id'] = user[0]['id']
			return redirect('/wall')
		# Incorrect password:
		else:
			flash('red')
			flash('Login failed: incorrect password, please try again.')
			return redirect('/')
	# Else email not registered:
	else:
		flash('red')
		flash('Login failed: email not found, please register.')
		return redirect('/')

@app.route('/register', methods=['POST'])
def register():
	data = 	{	'first_name': request.form.get('first_name'),
				'last_name': request.form.get('last_name'),
				'email': request.form.get('email'),
				'password': request.form.get('password'),
				'confirm_password': request.form.get('confirm_password')				
			}
	
	# Check if any fields are empty:				
	for key, value in data.iteritems():
		if len(value) == 0:
			flash('red')
			flash('Registration failed: please fill in all form fields.')
			return redirect('/')

	# Check for valid first name:
	if len(data['first_name']) < 2 or not data['first_name'].isalpha():
		flash('red')
		flash('Registration failed: please enter a valid first name (letters only).')
		return redirect('/')

	# Check for valid last name:
	if len(data['last_name']) < 2 or not data['last_name'].isalpha():
		flash('red')
		flash('Registration failed: please enter a valid last name (letters only).')
		return redirect('/')

	# Check for valid email:
	if not EMAIL_REGEX.match(request.form['email']):
		flash("red")
		flash("Registration failed: please enter a valid email (example: name@mailserver.com)")
		return redirect('/')

	# Check if the email is a new/unique entry:
	query = """SELECT email FROM users
				WHERE email = :email LIMIT 1
			"""
	if len(mysql.query_db(query, data)) > 0:
		flash("red")		
		flash("Registration failed: email already registered, please log in.")
		return redirect('/')

	# Check password length:
	if len(data['password']) < 8:
		flash('red')
		flash('Registration failed: password must be at least 8 characters long.')
		return redirect('/')

	# Check if the password matches the confirmation:
	if data['password'] != data['confirm_password']:
		flash('red')
		flash('Registration failed: password confirmation does not match.')
		return redirect('/')

	# All conditions met. Encrypt password and add to database:
	data['password'] = bcrypt.generate_password_hash(data['password'])

	# All conditions met, register new user:
	query = """	INSERT INTO users (first_name, last_name, email, 
				password, created_at, updated_at)
				VALUES (:first_name, :last_name, :email, :password, NOW(), NOW())
			"""
	mysql.query_db(query, data)
	flash('green')		
	flash('Registration complete! Please log in to continue.')
	return redirect('/')

@app.route('/wall')
def wall():
	# Get current user information:
	data = 	{'user_id': session.get('user_id')}
	query = """SELECT * FROM users
				WHERE id = :user_id LIMIT 1
			"""
	user = mysql.query_db(query, data)[0]

	# Get all messages and their authors:
	query = """SELECT messages.message as message, messages.id as message_id,
				messages.user_id as user_id,	
				CONCAT(users.first_name, ' ', users.last_name) as name,
				DATE_FORMAT(messages.created_at, '%M %D, %Y (%H:%i %p)') as message_date 
				FROM messages
				LEFT JOIN users on messages.user_id = users.id
				ORDER BY messages.created_at DESC
			"""	
	messages = mysql.query_db(query)
	
	# Get all comments and their corresponding authors and messages:
	query = """SELECT comments.comment as comment, comments.id as comment_id,
				comments.message_id as message_id, comments.user_id as user_id,	
				CONCAT(users.first_name, ' ', users.last_name) as name,
				DATE_FORMAT(comments.created_at, '%M %D, %Y (%H:%i %p)') as comment_date
				FROM comments
				LEFT JOIN users on comments.user_id = users.id
				ORDER BY comments.created_at ASC
			"""
	comments = mysql.query_db(query, data)

	return render_template('wall.html', user=user, messages=messages, comments=comments)

@app.route('/wall/submit_message', methods=['POST'])
def submit_message ():
	# Get current user information:
	data = 	{'user_id': session.get('user_id')}
	query = """SELECT * FROM users
				WHERE id = :user_id LIMIT 1
			"""
	user = mysql.query_db(query, data)[0]

	# Do not post empty message:
	if len(request.form.get('message')) == 0:
		flash('red')
		flash('Error: cannot post empty message.')		
	else:	
		data['message'] = request.form.get('message')			
		query = """	INSERT INTO messages (user_id, message, created_at, updated_at)
					VALUES (:user_id, :message, NOW(), NOW())
				"""
		mysql.query_db(query, data)
		flash('green')
		flash('New message posted!')

	return redirect('/wall')

@app.route('/wall/submit_comment/<message_id>', methods=['POST'])
def submit_comment(message_id = None):
	# Get current user information:
	data = 	{'user_id': session.get('user_id')}
	query = """SELECT * FROM users
				WHERE id = :user_id LIMIT 1
			"""
	user = mysql.query_db(query, data)[0]

	# Do not post empty comment:		
	if len(request.form.get('comment')) == 0:
		flash('red')
		flash('Error: cannot post empty comment.')		
	else:	
		data['comment'] = request.form.get('comment')		
		data['message_id'] = message_id	
		query = """	INSERT INTO comments (message_id, user_id, comment, created_at, updated_at)
					VALUES (:message_id, :user_id, :comment, NOW(), NOW())
				"""
		mysql.query_db(query, data)	
		flash('green')
		flash('New comment posted!')		

	return redirect('/wall')

@app.route('/wall/delete_message/<message_id>')
def delete_message (message_id):
	data = 	{'message_id': message_id}
	# Delete comments first:	
	query = "DELETE FROM comments WHERE comments.message_id = :message_id"
	mysql.query_db(query, data)
	# Then delete messages:
	query = "DELETE FROM messages WHERE messages.id = :message_id"
	mysql.query_db(query, data)

	flash('green')
	flash('Successfully deleted post.')

	return redirect('/wall')

@app.route('/wall/delete_comment/<comment_id>')
def delete_comment(comment_id = None):
	# Delete message:
	data = 	{'comment_id': comment_id}
	query = "DELETE FROM comments WHERE comments.id = :comment_id"
	mysql.query_db(query, data)

	flash('green')
	flash('Successfully deleted post.')

	return redirect('/wall')

	return redirect('/wall')

@app.route('/logout')
def logout():
	flash('green')
	flash('Successfully logged out.')
	session.clear();
	return redirect('/')	

app.run(debug=True)