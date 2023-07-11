# password_manager
This branch consists of a Python program to manage passwords of user across different websites. The user data is stored in a text file. It can also generate password if needed.

The project uses `Tkinter` module to create user interface. Once the user enters the required data and clicks `Add` button, a pop-up message for confirmation comes up. Upon confirmation, the data is saved in a txt file (here it's `passwords.txt`).

If the user clicks `Generate Password` button, then a new password will be randomly generated. This password will be copied to clipboard automatically. Then clicking Add button and similar procedure to step 4 occurs.

Libraries imported:
  1. tkinter               -->    For the Graphical User Interface
  2. messagebox            -->    For pop-up messages
  3. pyperclip             -->    To copy generated password to clipboard
  4. password_generator    -->    Not an in-built module. Password is generated here
