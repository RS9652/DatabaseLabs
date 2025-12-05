
import tkinter as tk
from tkinter import ttk as ttk
import tkinter.messagebox as mb
import tkinter.simpledialog as sb
import psycopg2
from gui_functions import *

#Establish a connection to the PostGRE database
try:
    connector = psycopg2.connect(
        host = "localhost",
        database = "warehouse",
        user = "postgres",
        password = "HokageYamm2004#",
        port = "5432"
    )
    cursor = connector.cursor()

    # Example: Execute a query
    cursor.execute("SELECT version();")
    db_version = cursor.fetchone()
    print(f"Connected to PostgreSQL database version: {db_version[0]}")
    print("Connection established")
except Exception as e:
    print(f"Error connecting to PostgreSQL: {e}")

#Functions
def clear_fields():
    global item_quantity, item_name, item_status

    for i in ['item_quantity','item_name', 'item_status']:
        exec (f"{i}.set('')")


def display_records():
    global connector, cursor
    global tree

    tree.delete(*tree.get_children())

    cursor.execute('SELECT id, name, quantity, item_status FROM item ORDER BY id')
    data = cursor.fetchall()

    for records in data:
        tree.insert('', tk.END, values=records)


def clear_and_display():
    clear_fields()
    display_records()
def add_record():
    global cursor
    global item_name, item_id, item_status, item_quantity

    surety = mb.askyesno("Confirmation", "Are you sure you want to add this record?")
    if surety:
        try:
            cursor.execute(
                'INSERT INTO item (name, quantity, item_status) VALUES (%s, %s, %s)',
                (item_name.get(), item_quantity.get(), item_status.get())
            )
            connector.commit()
            clear_and_display()

            mb.showinfo("Success", "Record added successfully")
        except psycopg2.IntegrityError:
            mb.showerror("Error", f"An error occurred: {e}")


def on_click():
    print("DA")
def on_resize(event):
    current_width = root.winfo_width()
    current_height = root.winfo_height()
    #print(f"Current window size: {current_width}x{current_height}")TODO in case of any error remove #
    # Update your UI elements here
    left_frame.place_configure(y=current_height * 0.1)  # Example: 10% from top
    right_top_frame.place_configure(x=current_width * 0.3, y=current_height * 0.1)
    right_bottom_frame.place(x=current_width * 0.3, y=current_height * 0.28)


# Tkinter window
root = tk.Tk()
root.title("Warehouse Management System")
root.geometry("1010x530")
#root.bind('<Configure>', on_resize)
root.resizable(0, 0)

#Colors of frames
top_hl_bg = 'SteelBlue'
top_hl_fg = 'White'
lf_bg = 'DeepSkyBlue' # Left Frame Background Color
lf_fg = 'White'
rtf_bg = 'Blue'
rtf_fg = '' #TODO pick color
rbf_bg = 'White'
rbf_fg = 'Black'#TODO pick color

#Font
lbl_font = ('Georgia', 13)  # Font for all labels
entry_font = ('Times New Roman', 12)  # Font for all Entry widgets
btn_font = ('Gill Sans MT', 13)

#String Variables
item_name = tk.StringVar()
item_status = tk.StringVar()
item_id = tk.StringVar()
item_quantity = tk.IntVar()

label = tk.Label(root, text = "Warehouse Management System", font =('Arial',14,"bold"), bg=top_hl_bg, fg=top_hl_fg)
label.pack(side = tk.TOP, fill = tk.X)
label.place(x=0, y=0, relwidth=1, relheight = 0.1)

#Frames
left_frame = tk.Frame(root, bg=lf_bg)
left_frame.place(x=0, y=53 , relwidth=0.3, relheight=0.96)

right_top_frame = tk.Frame(root, bg=rtf_bg)
right_top_frame.place(relx=0.3, y=53, relheight=0.25, relwidth=0.7)

right_bottom_frame = tk.Frame(root, bg=rbf_bg)
right_bottom_frame.place(relx=0.3, rely=0.3, relheight=0.785, relwidth=0.7)


#Butons
add_record_button = ttk.Button(left_frame, text="ADD RECORD", command=add_record, width = 20)
add_record_button.place(relx = 0.5, rely = 0.8, anchor = tk.CENTER)

clear_fields_button= ttk.Button(left_frame, text="Clear fields", command=on_click, width = 20)
clear_fields_button.place(relx = 0.5, rely = 0.9, anchor = tk.CENTER)

delete_item_button = ttk.Button(right_top_frame, text="Delete item", command=on_click, width = 20)
delete_item_button.place(relx = 0.15, rely = 0.5, anchor = tk.W)

delete_all_inventory_button = ttk.Button(right_top_frame, text="Clear inventory", command=on_click, width = 20)
delete_all_inventory_button.place(relx = 0.3, rely = 0.5, anchor = tk.W)

update_record_button = ttk.Button(right_top_frame, text = "Update an item", command=on_click, width = 20)
update_record_button.place(relx = 0.45, rely = 0.5, anchor = tk.W)

#Left Frame Widgets
tk.Label(left_frame, text = 'Item Name', font = lbl_font, bg = lf_bg, fg = lf_fg, width = 20).place(relx = 0.5, rely = 0.1, anchor = tk.CENTER)
ttk.Entry(left_frame, font = entry_font, textvariable = item_name, width = 20).place(relx = 0.5, rely = 0.2, anchor = tk.CENTER)

tk.Label(left_frame, text = 'Item Quantity', font = lbl_font, bg = lf_bg, fg = lf_fg, width = 20).place(relx = 0.5, rely = 0.3, anchor = tk.CENTER)
ttk.Entry(left_frame, font = entry_font, textvariable = item_quantity, width = 20).place(relx = 0.5, rely = 0.4, anchor = tk.CENTER)

tk.Label(left_frame, text = 'Item Status', font = lbl_font, bg = lf_bg, fg = lf_fg, width = 20).place(relx = 0.5, rely = 0.5, anchor = tk.CENTER)
ttk.Entry(left_frame, font = entry_font, textvariable = item_status, width = 20).place(relx = 0.5, rely = 0.6, anchor = tk.CENTER)

#Right top frame widgets


#Right bottom frame widgets
tk.Label(right_bottom_frame, text='ITEM INVENTORY', bg=rbf_bg, font=("Noto Sans CJK TC", 15, 'bold')).pack(side=tk.TOP, fill=tk.X, anchor=tk.CENTER)
 
tree = ttk.Treeview(right_bottom_frame, selectmode=tk.BROWSE, columns=('Item ID', 'Item Name', 'Quantity', 'Status'), show='headings')
XScrollbar = tk.Scrollbar(tree, orient=tk.HORIZONTAL, command=tree.xview)
YScrollbar = tk.Scrollbar(tree, orient=tk.VERTICAL, command=tree.yview)

XScrollbar.pack(side=tk.BOTTOM, fill=tk.X)
YScrollbar.pack(side=tk.RIGHT, fill=tk.Y)

tree.config(xscrollcommand=XScrollbar.set, yscrollcommand=YScrollbar.set)

tree.heading('Item ID', text='ID', anchor=tk.CENTER)
tree.heading('Item Name', text='Item Name', anchor=tk.CENTER)
tree.heading('Quantity', text='Quantity', anchor=tk.CENTER)
tree.heading('Status', text='Status of the Item', anchor=tk.CENTER)

tree.column('#0', width=0, stretch=tk.NO)
tree.column('#1', width=30, stretch=tk.NO)
tree.column('#2', width=80, stretch=tk.NO)
tree.column('#3', width=120, stretch=tk.NO)
tree.column('#4', width=200, stretch=tk.NO)

tree.place(y=30, x=0, relheight=0.9, relwidth=1)

clear_and_display()

root.update()
root.mainloop()