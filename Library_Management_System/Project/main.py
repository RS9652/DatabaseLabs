
import tkinter as tk
from tkinter import ttk as ttk
import tkinter.messagebox as mb
import tkinter.simpledialog as sb
import psycopg2




# Tkinter window

root = tk.Tk()
root.title("Warehouse Management System")
root.geometry("1050x600")
root.resizable(0, 0)


#Colors of frames
top_hl_bg = 'SteelBlue'
top_hl_fg = 'White'
lf_bg = 'DeepSkyBlue'
lf_fg = 'White'
rtf_bg = 'Blue'
rtf_fg = '' #TODO pick color
rbf_bg = 'White'
rbf_fg = ''#TODO pick color





label = tk.Label(root, text = "Warehouse Management System", font =('Arial',14,"bold"), bg=top_hl_bg, fg=top_hl_fg)
label.pack(side = tk.TOP, fill = tk.X)
label.place(x=0, y=0, relwidth=1, relheight = 0.1)


#Frames
left_frame = tk.Frame(root, bg=lf_bg)
left_frame.place(x=0, y=60, relwidth=0.3, relheight=0.9)

right_top_frame = tk.Frame(root, bg=rtf_bg)
right_top_frame.place(x=315, y=60, relwidth=1, relheight=0.18)

right_bottom_frame = tk.Frame(root, bg="White")
right_bottom_frame.place(x=315, y=168, relwidth=1, relheight=1)



def on_click():
    label.config(text="Button Clicked")

#Butons
add_record = ttk.Button(left_frame, text="ADD RECORD", command=on_click)
add_record.pack()
clear_fields = ttk.Button(left_frame, text="Clear fields", command=on_click)
clear_fields.pack()
delete_item = ttk.Button(right_top_frame, text="Delete item", command=on_click)
delete_item.pack()
delete_all_inventory = ttk.Button(right_top_frame, text="Clear inventory", command=on_click)
delete_all_inventory.pack()
update_record = ttk.Button(right_top_frame, text = "update an item", command=on_click)

root.mainloop()