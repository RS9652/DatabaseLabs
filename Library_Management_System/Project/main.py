
import tkinter as tk
from tkinter import ttk as ttk
import tkinter.messagebox as mb
import tkinter.simpledialog as sb
import psycopg2
from gui_functions import *


#Colors of frames
top_hl_bg = 'SteelBlue'
top_hl_fg = 'White'
lf_bg = 'DeepSkyBlue' # Left Frame Background Color
lf_fg = 'White'
rtf_bg = 'Blue'
rtf_fg = '' #TODO pick color
rbf_bg = 'White'
rbf_fg = ''#TODO pick color

#Font
lbl_font = ('Georgia', 13)  # Font for all labels
entry_font = ('Times New Roman', 12)  # Font for all Entry widgets
btn_font = ('Gill Sans MT', 13)

#String Variables
item_name = tk.StringVar
item_status = tk.StringVar
item_id = tk.StringVar
item_quantity = tk.IntVar

# Tkinter window
root = tk.Tk()
root.title("Warehouse Management System")
root.geometry("1050x600")
root.resizable(0, 0)

label = tk.Label(root, text = "Warehouse Management System", font =('Arial',14,"bold"), bg=top_hl_bg, fg=top_hl_fg)
label.pack(side = tk.TOP, fill = tk.X)
label.place(x=0, y=0, relwidth=1, relheight = 0.1)

#Functions
def on_click():
    label.config(text="Button Clicked")


#Frames
left_frame = tk.Frame(root, bg=lf_bg)
left_frame.place(x=0, y=60, relwidth=0.3, relheight=0.9)

right_top_frame = tk.Frame(root, bg=rtf_bg)
right_top_frame.place(x=315, y=60, relwidth=1, relheight=0.18)

right_bottom_frame = tk.Frame(root, bg=rbf_bg)
right_bottom_frame.place(x=315, y=168, relwidth=1, relheight=1)


#Butons
add_record = ttk.Button(left_frame, text="ADD RECORD", command=on_click, width = 20)
add_record.place(relx = 0.5, rely = 0.8, anchor = tk.CENTER)

clear_fields = ttk.Button(left_frame, text="Clear fields", command=on_click, width = 20)
clear_fields.place(relx = 0.5, rely = 0.9, anchor = tk.CENTER)

delete_item = ttk.Button(right_top_frame, text="Delete item", command=on_click, width = 20)
delete_item.place(relx = 0.15, rely = 0.5, anchor = tk.W)

delete_all_inventory = ttk.Button(right_top_frame, text="Clear inventory", command=on_click, width = 20)
delete_all_inventory.place(relx = 0.3, rely = 0.5, anchor = tk.W)

update_record = ttk.Button(right_top_frame, text = "Update an item", command=on_click, width = 20)
update_record.place(relx = 0.45, rely = 0.5, anchor = tk.W)

#Left Frame Widgets
tk.Label(left_frame, text = 'Item Name', font = lbl_font, bg = lf_bg, fg = lf_fg, width = 20).place(relx = 0.5, rely = 0.1, anchor = tk.CENTER)
ttk.Entry(left_frame, font = entry_font, textvariable = item_name, width = 20).place(relx = 0.5, rely = 0.2, anchor = tk.CENTER)

tk.Label(left_frame, text = 'Item Id', font = lbl_font, bg = lf_bg, fg = lf_fg, width = 20).place(relx = 0.5, rely = 0.3, anchor = tk.CENTER)
ttk.Entry(left_frame, font = entry_font, textvariable = item_id, width = 20).place(relx = 0.5, rely = 0.4, anchor = tk.CENTER)

tk.Label(left_frame, text = 'Item Status', font = lbl_font, bg = lf_bg, fg = lf_fg, width = 20).place(relx = 0.5, rely = 0.5, anchor = tk.CENTER)
ttk.Entry(left_frame, font = entry_font, textvariable = item_status, width = 20).place(relx = 0.5, rely = 0.6, anchor = tk.CENTER)

root.mainloop()