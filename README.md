# 📝 Bash Task Organizer

A lightweight, terminal-based task management tool written in Bash. This script allows you to manage your daily tasks directly from your CLI using a simple pipe-separated text database.

## ✨ Features

* **Colorized Interface:** Easy-to-read, color-coded terminal output.
* **CRUD Operations:** Add, List, Update, and Delete tasks with a confirmation step for deletions.
* **Advanced Filtering & Sorting:** Within the list view, filter tasks by priority or status, and sort them by date or importance.
* **Smart Date Handling:** Input dates as `YYYY-MM-DD` (with regex validation) or enter a number to set a deadline relative to today.
* **Regex Search:** Case-insensitive search that now supports regular expressions for finding tasks.
* **Detailed Reporting:** Generate status summaries, identify overdue tasks, and view priority breakdowns.
* **CSV Export:** Export your task database to a standard `.csv` format for use in Excel or other tools.
* **Persistent Storage:** Saves all tasks to a local `tasks_db` file.

---

## 🚀 Getting Started

### Prerequisites

You will need a Unix-like environment (Linux, macOS, WSL) with the following utilities:

* `bash`
* `awk`
* `sed`
* `column`

### Installation

1. Save the script as `tsk.sh`.
2. Give the script execution permissions:
```bash
chmod +x tsk.sh

```



### Usage

Run the script to start the interactive menu:

```bash
./tsk.sh

```

---

## 🛠 Menu Options

| Option | Action | Description |
| --- | --- | --- |
| **1** | **Add Task** | Create a task with title, priority (h/m/l), and validated due date. |
| **2** | **List Tasks** | View tasks with an interactive sub-menu for **filtering and sorting**. |
| **3** | **Update Task** | Modify any field of an existing task using an efficient case-driven menu. |
| **4** | **Delete Task** | Remove a task by ID (includes a **safety confirmation prompt**). |
| **5** | **Search** | Find tasks using keywords or **Regex patterns**. |
| **6** | **Reports** | Access **Overdue Task** alerts, Status Summaries, and Priority Reports. |
| **7** | **Export to CSV** | Convert and save your database into a `.csv` file. |
| **9** | **Quit** | Exit the application. |

---

## 📂 Database Structure

The script automatically creates a file named `tasks_db` in the same directory. Data is stored in the following format:
`ID|TITLE|PRIORITY|DATE|STATUS`

> [!TIP]
> The **Overdue Report** calculates deadlines based on your system's current date—tasks marked as "done" are excluded from overdue alerts.

---

## ⚖️ License

This project is open-source and free to use.

**Created by Ali**
