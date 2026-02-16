#!/usr/bin/bash

# Echo + Colors
echor() { echo -e "\e[31m$*\e[0m"; }
echog() { echo -e "\e[32m$*\e[0m"; }
echoy() { echo -e "\e[33m$*\e[0m"; }
echob() { echo -e "\e[34m$*\e[0m"; }

echob "  _______        _       ____                        _                _____           _           _   ";
echob " |__   __|      | |     / __ \\                      (_)              |  __ \\         (_)         | |  ";
echob "    | | __ _ ___| | __ | |  | |_ __ __ _  __ _ _ __  _ _______ _ __  | |__) | __ ___  _  ___  ___| |_ ";
echob "    | |/ _\` / __| |/ / | |  | | '__/ _\` |/ _\` | '_ \\| |_  / _ \\ '__| |  ___/ '__/ _ \\| |/ _ \\/ __| __|";
echob "    | | (_| \\__ \\   <  | |__| | | | (_| | (_| | | | | |/ /  __/ |    | |   | | | (_) | |  __/ (__| |_ ";
echob "    |_|\\__,_|___/_|\\_\\  \\____/|_|  \\__, |\\__,_|_| |_|_/___\\___|_|    |_|   |_|  \\___/| |\\___|\\___|\\__|";
echob "  ____                   _ _        __/ |             _                             _/ |              ";
echob " |  _ \\            /\\   | (_)     /\\___/ |           | |                           |__/               ";
echob " | |_) |_   _     /  \\  | |_     /  \\  | | __ _  ___ | |__   __ _ _ __ _   _                          ";
echob " |  _ <| | | |   / /\\ \\ | | |   / /\\ \\ | |/ _\` |/ _ \\| '_ \\ / _\` | '__| | | |                         ";
echob " | |_) | |_| |  / ____ \\| | |  / ____ \\| | (_| | (_) | | | | (_| | |  | |_| |                         ";
echob " |____/ \\__, | /_/    \\_\\_|_| /_/    \\_\\_|\\__, |\\___/|_| |_|\\__,_|_|   \\__, |                         ";
echob "         __/ |                             __/ |                        __/ |                         ";
echob "        |___/                             |___/                        |___/                          ";

valid(){
    if [[ $1 == "" || $1 =~ \| ]]; then
	echor "Not a valid input"
	return 1
    else
	echog "Valid input"
	return 0
    fi 
}

add_task(){
    echog ======= Add Task =======
    read -p "Enter title: " title
    valid "$title"
    if [[ $? -eq 1 ]]; then
	return 1
    fi

    read -p "Enter priority (h: high, m: medium, l: low): " pr

    if [[ $pr == "h" ]]; then priority="high";
    elif [[ $pr == "m" ]]; then priority="medium";
    elif [[ $pr == "l" ]]; then priority="low"; 
    else echor "Not a valid priority"; return 1; fi
    regex="^[0-9]{4}-[0-9]{2}-[0-9]{2}$"
    read -p "Enter Due Date: yyyy-mm-dd, you can also write a number to represent days after today: " dt
    if [[ $dt =~ ^[0-9]+$ ]]; then
	dt=$(date -d "+$dt days" +%F);

    elif [[ $dt =~  $regex ]]; then
	date -d $dt >/dev/null 2>&1
	if [[ $? -eq 1 ]]; then echor "Not a valid date"; return 1; fi
    else
	echor "Not a valid date"; return 1;
    fi
    echo Entered due date is: $dt
    
    status="pending"
    tid=1
    tid=$(awk 'BEGIN {FS="|"; } END { print $1 }' $db_path)
    if [[ $tid == "ID" ]]; then tid=0; fi
    
    tid=$(($tid+1))

    echog "$tid|$title|$priority|$dt|$status"
    echo "$tid|$title|$priority|$dt|$status" >> $db_path
    echog "Task added successfully"
    
}

list_tasks(){
    echog ======= List Tasks =======
    cat $db_path | column -t -s "|"

    while [ 1 ]
    do
        echo -e "\n"
	echo 0 All
        echo 1 Priority high only
        echo 2 Priority medium only
        echo 3 Priority low only
        echo 4 Status pending only
        echo 5 Status in-progress only
        echo 6 Status done only
	echo 9 Quit

        read -p "Enter filtering choice: " choice
	clear
	if [[ ! "$choice" =~ ^[0-9]+$ ]]; then
            echor Not a valid choice

        elif [[ $choice -eq 0 ]]; then
	    cat $db_path | column -t -s "|"

        elif [[ $choice -eq 1 ]]; then
            res=$(awk -F '|' '$3 == "high"' $db_path)
	    echo -e "$header\n$res" | column -t -s "|"
	    
        elif [[ $choice -eq 2 ]]; then
	    res=$(awk -F '|' '$3 == "medium"' $db_path)
            echo -e "$header\n$res" | column -t -s "|"

        elif [[ $choice -eq 3 ]]; then
	    res=$(awk -F '|' '$3 == "low"' $db_path)
            echo -e "$header\n$res" | column -t -s "|"

        elif [[ $choice -eq 4 ]]; then
	    res=$(awk -F '|' '$5 == "pending"' $db_path)
            echo -e "$header\n$res" | column -t -s "|"

        elif [[ $choice -eq 5 ]]; then
	    res=$(awk -F '|' '$5 == "in-progress"' $db_path)
            echo -e "$header\n$res" | column -t -s "|"

        elif [[ $choice -eq 6 ]]; then
	    res=$(awk -F '|' '$5 == "done"' $db_path)
            echo -e "$header\n$res" | column -t -s "|"

        elif [[ $choice -eq 9 ]]; then
    	    break
    	fi
    done
}

update_task(){
    echog ======= Update Task =======
    cat $db_path | column -t -s "|"
    echo -e "\n"

    read -p "Enter id of the task to be updated: " id
    task=$(awk -F '|' -v id="$id" '$1 == id' $db_path)
    if [[ $task == "" || $id == "id" ]]; then echor "No record found"; return 1; fi
    
    while [ 1 ]
    do
        task=$(awk -F '|' -v id="$id" '$1 == id' $db_path)
	echog $task
        echo 1 Update title
        echo 2 Update priority
        echo 3 Update date
        echo 4 Update status
        echo 9 Quit
        read -p "Enter your update choice: " update_choice

	case $update_choice in
	    1) read -p "Enter new title: " title
               valid "$title"
               if [[ $? -eq 1 ]]; then
                   continue
               fi
               new=$(awk -F '|' -v id="$id" -v title="$title" -v OFS="|" '$1 == id {$2=title;print $0}' $db_path)
	       sed -i "s/$task/$new/" $db_path
               echog "Record updated successfully" 
            ;;

            2) read -p "Enter new priority (h, m, l): " pr

               if [[ $pr == "h" ]]; then priority="high";
               elif [[ $pr == "m" ]]; then priority="medium";
    	       elif [[ $pr == "l" ]]; then priority="low"; 
               else echor "Not a valid priority"; continue; fi
            
               new=$(awk -F '|' -v id="$id" -v pri="$priority" -v OFS="|" '$1 == id {$3=pri;print $0}' $db_path)
	       sed -i "s/$task/$new/" $db_path
            ;;

            3) read -p "Enter Due Date: yyyy-mm-dd, you can also write a number to represent days after today: " dt
               if [[ $dt =~ ^[0-9]+$ ]]; then dt=$(date -d "+$dt days" +%F); fi
               echo Entered due date is: $dt
               dt=$(date -d $dt +%F)
	       date -d $dt >/dev/null 2>&1
            
               if [[ $? -eq 1 ]]; then echor "Not a valid date"; continue; fi
            
	       new=$(awk -F '|' -v id="$id" -v dt="$dt" -v OFS="|" '$1 == id {$4=dt;print $0}' $db_path)
	       sed -i "s/$task/$new/" $db_path
	   ;;

   	    4) read -p "Enter new status (p: pending, i: in-progress, d: done): " st

               if [[ $st == "p" ]]; then stat="pending";
               elif [[ $st == "i" ]]; then stat="in-progress";
    	       elif [[ $st == "d" ]]; then stat="done"; 
               else echor "Not a valid status"; continue; fi
            
               new=$(awk -F '|' -v id="$id" -v stat="$stat" -v OFS="|" '$1 == id {$5=stat;print $0}' $db_path)
	       sed -i "s/$task/$new/" $db_path
	    ;;

    	   9) echoy Quitting; break;;
           *) echor Not a valid choice ;;

	esac

        echoy "\n---------------\n"
    done
}

delete_task(){
    echog ======= Delete Task =======
    cat $db_path | column -t -s "|"
    read -p "Enter id of the task to be deleted: " id
    read -p "Are you sure? This Action is irreversable (y or n): " choice
    if [[ $choice == "y" ]]; then
        task=$(awk -F '|' -v id="$id" '$1 == id' $db_path)
        if [[ $task == "" || $id == "ID" ]]; then echor "No record found"; return 1; fi
        sed -i "/$task/d" $db_path
        echog "Task deleted successfully" 
    fi
}

search_tasks(){
    echog ======= Search Tasks =======
    read -p "Enter search term: " query
    query=${query,,}
    res=$(tail -n +2 $db_path | awk -F '|' -v q="$query" 'tolower($2) ~ q')
    echo -e "$header\n$res" | column -t -s "|"
}
reports(){
    while [[ 1 ]] do
        echo 1 Task Summary 
        echo 2 Overdue Tasks
        echo 3 Priority Report
        echo 9 Quit
        read -p "Enter report type: " choice
        clear
	case $choice in
	    1)
	        res=$(awk -F '|' '
		BEGIN {
		print "PENDING", "IN-PROGRESS","DONE";
		    sum1=0;
		    sum2=0;
		    sum3=0;
	        } {
		 if($5 == "pending"){
		     sum1 = sum1 + 1;
		 }
		 else if ($5 == "in-progress"){
		     sum2 = sum2 + 1;
		 }
		 else if ($5 == "done"){
		     sum3 = sum3 + 1;
		 }
	
	
   	        } END {
		    print sum1,sum2,sum3
	    }' $db_path | column -t)
	       echog "$res"
            ;;
	    2)
		today=$(date +%s)
	        res=$(tail -n +2 $db_path | awk -F '|' -v today="$today" '
	       	{
		    cmd="date -d " $4 " +%s"
		    cmd | getline task_due
		    close(cmd)

		    if(task_due <= today && $5 != "done"){
		        print $0
		    }
		}')
		num=$(echo "$res" | grep -v '^$' | wc -l)
		res="$header\n$res"
                
		echoy ===== You have $num unfinished overdue tasks =====
		
		echor "$res" | column -t -s "|"
	    ;;

	    3)
		echog ===== Priority Report =====
		
		res_high=$(awk -F '|' '$3 == "high"' $db_path)
	        res_med=$(awk -F '|' '$3 == "medium"' $db_path)
	        res_low=$(awk -F '|' '$3 == "low"' $db_path)
		
	  	echor "You have $(echo -e "$res_high" | grep -v '^$' | wc -l) high priority tasks"
		echoy "You have $(echo -e "$res_med" | grep -v '^$' | wc -l) medium priority tasks"
		echog "You have $(echo -e "$res_low" | grep -v '^$' | wc -l) low priority tasks"
                echo

		res_high="$header\n$res_high\n"
		echor "$res_high" | column -t -s "|"
		
		res_med="$header\n$res_med\n"
                echoy "$res_med" | column -t -s "|"

		res_low="$header\n$res_low\n"
                echog "$res_low" | column -t -s "|"

	    ;;
            
	    9) echoy Quitting; break;;
	    *) echor Not a valid choice;;
	    

	esac
    echo -e "\n"
    done
}

db_path="$(pwd)/tasks_db"
test -f $db_path
if [ $? -eq 0 ]; then
    echog ===== using tasks from $db_path =====
else
    echo "ID|TITLE|PRIORITY|DATE|STATUS" > $db_path
    echog ===== Created tasks in $db_path =====
fi
header=$(head -1 $db_path)
choice=0
while [ 1 ]
do
    echob 1 Add Task
    echob 2 List Tasks
    echob 3 Update Task
    echob 4 Delete Task
    echob 5 Search
    echob 6 Reports
    echob 9 Quit
    read -p "Enter your Choice: " choice
    clear

    case $choice in
	1) add_task;;
        2) list_tasks;;
	3) update_task;;
	4) delete_task;;
	5) search_tasks;;
	6) reports;;
	9) echoy Quitting; break;;
	*) echor Not a valid choice;;
    esac
    echoy "\n---------------\n"
done
