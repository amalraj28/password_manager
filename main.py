import tkinter as tk                # Create GUI
from tkinter import messagebox      # To show dialog boxes
import password_generator           # Password is generated here
import pyperclip                    # To copy the generated password to clipboard

DEFAULT_EMAIL = 'DEFAULT'     # Store default email in this variable
FILE = 'passwords.txt'        # Enter relative path of file where user data is to be stored

# ---------------------------- PASSWORD GENERATOR ------------------------------- #


def generate_pass():
    new_pass = password_generator.create_password()
    password_input.delete(0, len(password_input.get()))
    password_input.insert(0, new_pass)
    pyperclip.copy(new_pass)


# ---------------------------- SAVE PASSWORD ------------------------------- #

def add_data():
    web = website_input.get()
    email = email_input.get()
    password = password_input.get()

    if web == '' or email == '' or password == '':
        messagebox.showerror(title='Error', message='One or more fields are empty!!')

    else:
        data_is_ok = messagebox.askokcancel(title=web,
                                            message=f'These are the details entered:\n Website: {web}\n Email: {email}\n Password: {password}\n '
                                                    f'Do you want to save it?')

        if data_is_ok:
            with open(FILE, 'a') as data:
                data.write(f'{web} | {email} | {password} \n')
                website_input.delete(0, len(web))
                email_input.delete(0, len(email))
                password_input.delete(0, len(password))

    website_input.focus()


# ---------------------------- UI SETUP ------------------------------- #

window = tk.Tk()
window.title('Password Manager')
window.config(padx=40, pady=40)

canvas = tk.Canvas(width=200, height=200)
logo = tk.PhotoImage(file='logo.png')  # File has to be specified as keyword attribute
canvas.create_image(100, 100, image=logo)
canvas.grid(row=0, column=1)

website = tk.Label(text='Website:')
website.grid(row=1, column=0)

website_input = tk.Entry(width=50)
website_input.grid(row=1, column=1, columnspan=2)

username = tk.Label(text='Username/Email:')
username.grid(row=2, column=0)

email_input = tk.Entry(width=50)
email_input.insert(0, DEFAULT_EMAIL)
email_input.grid(row=2, column=1, columnspan=2)

password_label = tk.Label(text='Password:')
password_label.grid(row=3, column=0)

password_input = tk.Entry(width=50)
password_input.grid(row=3, column=1, columnspan=2)

gen_pass = tk.Button(text='Generate Password', command=generate_pass)
gen_pass.grid(row=3, column=2)

add_button = tk.Button(text='Add', width=40)
add_button.grid(row=4, column=1, columnspan=2)
add_button.config(command=add_data)

window.mainloop()
