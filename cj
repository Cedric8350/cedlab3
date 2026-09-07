#include <iostream>
#include <string>
#include <iomanip>

using namespace std;

const int MAX_CAPACITY = 50;

struct Student {
    int id;
    string name;
};

int findStudentById(const Student roster[], int count, int targetId, int &comparisons);
bool addStudent(Student roster[], int &count, int id, const string &name);
bool removeStudentById(Student roster[], int &count, int targetId);
bool safeGetRecord(const Student roster[], int count, int index, Student &outStudent);
void printRoster(const Student roster[], int count);

int main() {
    Student roster[MAX_CAPACITY];
    int currentCount = 0;
    int choice = 0;

    do {
        cout << "\n=========================================\n";
        cout << "   NTC CC105: STUDENT ROSTER MANAGER    \n";
        cout << "=========================================\n";
        cout << "1. Add Student Record\n";
        cout << "2. Search Student by ID\n";
        cout << "3. Remove Student by ID\n";
        cout << "4. Safe Inspect Record by Index\n";
        cout << "5. Display Full Roster\n";
        cout << "6. Exit\n";
        cout << "Enter selection [1-6]: ";
        
        if (!(cin >> choice)) {
            cin.clear();
            cin.ignore(10000, '\n');
            cout << "Invalid input. Please enter a valid menu number.\n";
            continue;
        }

        switch (choice) {
            case 1: {
                if (currentCount >= MAX_CAPACITY) {
                    cout << "Error: Array overflow. Roster has reached MAX_CAPACITY (" 
                         << MAX_CAPACITY << ").\n";
                    break;
                }
                int id;
                string name;
                cout << "Enter Student ID: ";
                cin >> id;
                cin.ignore(10000, '\n');
                cout << "Enter Student Name: ";
                getline(cin, name);

                if (addStudent(roster, currentCount, id, name)) {
                    cout << "Student record successfully added.\n";
                } else {
                    cout << "Error: Insertion rejected. Duplicate ID detected or array full.\n";
                }
                break;
            }
            case 2: {
                if (currentCount == 0) {
                    cout << "Warning: Roster is currently empty.\n";
                    break;
                }
                int targetId;
                int comparisons = 0;
                cout << "Enter Student ID to search: ";
                cin >> targetId;

                int index = findStudentById(roster, currentCount, targetId, comparisons);
                if (index != -1) {
                    cout << "Record found at index " << index << ".\n";
                    cout << "ID: " << roster[index].id << " | Name: " << roster[index].name << "\n";
                } else {
                    cout << "Record with ID " << targetId << " not found.\n";
                }
                cout << "Total Element Comparisons: " << comparisons << "\n";
                break;
            }
            case 3: {
                if (currentCount == 0) {
                    cout << "Warning: Roster is currently empty.\n";
                    break;
                }
                int targetId;
                cout << "Enter Student ID to remove: ";
                cin >> targetId;

                if (removeStudentById(roster, currentCount, targetId)) {
                    cout << "Student removed successfully. Left-shift executed to preserve contiguity.\n";
                } else {
                    cout << "Error: Student ID not found in roster.\n";
                }
                break;
            }
            case 4: {
                if (currentCount == 0) {
                    cout << "Warning: Roster is currently empty.\n";
                    break;
                }
                int index;
                Student temp;
                cout << "Enter index to inspect: ";
                cin >> index;

                if (safeGetRecord(roster, currentCount, index, temp)) {
                    cout << "Valid Read [Index " << index << "] -> ID: " 
                         << temp.id << " | Name: " << temp.name << "\n";
                } else {
                    cout << "Error: Index " << index << " is out of bounds (Valid range: 0 to " 
                         << (currentCount - 1) << ").\n";
                }
                break;
            }
            case 5: {
                printRoster(roster, currentCount);
                break;
            }
            case 6: {
                cout << "Exiting system. Memory cleaned successfully.\n";
                break;
            }
            default:
                cout << "Invalid choice! Selection must be between 1 and 6.\n";
        }
    } while (choice != 6);

    return 0;
}


int findStudentById(const Student roster[], int count, int targetId, int &comparisons) {
    comparisons = 0;
    for (int i = 0; i < count; i++) {
        comparisons++;
        if (roster[i].id == targetId) {
            return i;
        }
    }
    return -1;
}

bool addStudent(Student roster[], int &count, int id, const string &name) {
    if (count >= MAX_CAPACITY) {
        return false;
    }

    int dummyComparisons = 0;
    if (findStudentById(roster, count, id, dummyComparisons) != -1) {
        return false; 
    }

    roster[count].id = id;
    roster[count].name = name;
    count++;
    return true;
}

bool removeStudentById(Student roster[], int &count, int targetId) {
    int comparisons = 0;
    int index = findStudentById(roster, count, targetId, comparisons);

    if (index == -1) {
        return false;
    }

    for (int i = index; i < count - 1; i++) {
        roster[i] = roster[i + 1];
    }

    count--;
    return true;
}

bool safeGetRecord(const Student roster[], int count, int index, Student &outStudent) {
    if (index < 0 || index >= count) {
        return false;
    }
    outStudent = roster[index];
    return true;
}

void printRoster(const Student roster[], int count) {
    if (count == 0) {
        cout << "Warning: Roster is currently empty.\n";
        return;
    }

    cout << "\n--------------------------------------------------\n";
    cout << left << setw(10) << "Index" << setw(15) << "Student ID" << setw(25) << "Name" << "\n";
    cout << "--------------------------------------------------\n";
    for (int i = 0; i < count; i++) {
        cout << left << setw(10) << i 
             << setw(15) << roster[i].id 
             << setw(25) << roster[i].name << "\n";
    }
    cout << "--------------------------------------------------\n";
    cout << "Active Records: " << count << " / " << MAX_CAPACITY << "\n";
}

/*
================================================================================
PERFORMANCE REFLECTION (WRITTEN TASK)
================================================================================

1. Random Access vs. Linear Search:
   - Direct inspection via `safeGetRecord` executes in $O(1)$ constant time 
     because C++ arrays reside in contiguous memory locations. Direct index 
     access utilizes memory address arithmetic:
     $$\text{Target Address} = \text{Base Address} + (\text{index} \times \text{sizeof}(\text{Student}))$$
     Because calculating this offset takes a fixed number of CPU clock cycles 
     regardless of the roster size, time complexity remains constant at $O(1)$.
   
   - Searching by ID via `findStudentById` requires $O(n)$ worst-case linear 
     time complexity because array elements are unsorted by default. The system 
     must iterate sequentially from index $0$ to $n-1$, performing up to $n$ 
     comparisons when an ID is located at the last slot or does not exist.

2. Deletion Cost:
   - Deleting an element at index $0$ represents the worst-case scenario for continuous 
     array maintenance, requiring $O(n)$ time complexity. Because arrays must maintain 
     contiguous memory without gaps, removing index $0$ forces every remaining 
     element ($n-1$ total records) to be shifted left by one slot.
   
   - Deleting an element at index `currentCount - 1` takes $O(1)$ constant time complexity. 
     Since the record is located at the tail end of the active array range, no elements 
     exist behind it, eliminating the need for left-shifting loops. Decrementing 
     `currentCount` by 1 instantly removes access to that memory location.
================================================================================
*/
