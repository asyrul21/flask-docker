# FlaskApi

1. Install flask
```python
pip install Flask
```

2. If you use Flask, you DO NOT NEED __init__.py

3. Create your app.py
```python
# import Flask
from flask import Flask, render_template, request
from markupsafe import escape

# import method classes
from inputProcessors.ResponseRetriever import ResponseRetriever
from inputProcessors.Classifiers import classifyInput

# create app instance
app = Flask(__name__)

#  add route
@app.route('/')
def hello_world():
    return render_template('index.html', title='Welcome to the flask API')


@app.route('/input/', methods=['GET', 'POST'])
def input():
    if(request.method == 'GET'):
        # get input
        message = request.args.get('message', '')

        # escape input message
        escapedMessage = escape(message)

        # classify input
        messageClass = classifyInput(message)

        # get reponse
        rr = ResponseRetriever()
        res = rr.getResponse(messageClass)

        # return response as json
        return {
            "source:": "bot",
            "input": message,
            "response": res
        }
    else:
        return 'You just made a POST request!'


# page 404
@app.errorhandler(404)
def page_not_found(error):
    return render_template('page_not_found.html'), 404
```

4. Run using
```bash
$ flask run
```

5. If you want to activate development mode:
```bash
$ export FLASK_ENV=development
```
This does the following things:

- it activates the debugger
- it activates the automatic reloader
- it enables the debug mode on the Flask application.

6. Deploying Flask Api

https://devcenter.heroku.com/articles/getting-started-with-python#deploy-the-app


# Using Flask Restful
1. Install
```bash
pip install flask-restful
```

2. Create app_restful.py
```python
# import Flask
from flask import Flask
# Flask restful
from flask_restful import Resource, Api, reqparse

# import resources
from Resources.HelloWorld import HelloWorld
from Resources.Input import Input

# create app instance
app = Flask(__name__)
# restful
api = Api(app)


# add resource to route
api.add_resource(HelloWorld, '/')
api.add_resource(Input, '/input/')


# enable ro disable debugging here
if __name__ == '__main__':
    app.run(debug=True)
```
3. Define and link to resources
```python
# define arguments parser
# reqparse is Resource specific
# i.e. args defined in here does not work in other Resources
parser = reqparse.RequestParser()
parser.add_argument('message', type=str,
                    help='The input string sent by the user')

# define data format
# may be optional
resource_fields = {
    'source': fields.String,
    'input': fields.String,
    'response': fields.String,
}

class Input(Resource):
    @marshal_with(resource_fields)
    def get(self):
        # get input
        message = parser.parse_args()['message']

        # escape input message
        escapedMessage = escape(message)

        # classify input
        messageClass = classifyInput(message)

        # get reponse
        rr = ResponseRetriever()
        res = rr.getResponse(messageClass)

        # return response as json
        return {
            "source:": "bot",
            "input": message,
            "response": res
        }

```

4. Run
```python
python app_restful.py
```
### Deploy Flask on Heroku

1. Install Gunicorn
```bash
pip install gunicorn
```

2. Create requirements.txt
*IMPORTANT* include ONLY dependencies you use in the app. Otherwise 
there will be problems when deploying to Heroku.
```bash
pip freeze > requirements.txt

# run this, choose from here and paste into requirements.txt
pip freeze > requirements_alt.txt
```

3. Create a new file with Procfile as the name and do not add any extension. Add this line below
```bash
web: gunicorn app:app
```
web is used by Heroku to start a web server for the application. The app:app specifies the module and application name. In our application we have the app module and our flask application is also called app. If your’s are different you can change them.

4. Commit changes
```bash
git add .
git commit -m "message"
git push
```
5. Deploy to heroku
```bash
heroku create <name>
git push heroku master
```
# API Call
You can now call the API
```bash
https://flask-restful-example.herokuapp.com/input/?message=hello
```

Response:
```json
{
    "source": "bot",
    "input": "hello",
    "response": "Hi there!"
}
```

# References

https://stackoverflow.com/questions/47304291/heroku-upload-could-not-find-a-version-that-satisfies-the-requirement-anaconda