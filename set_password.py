from notebook.auth import passwd

hashed_passwd = passwd()

with open("jupyter_notebook_config.py", "a") as config:
	config.write(f"c.NotebookApp.password = u'{hashed_passwd}'")