#include 
#include 
using namespace std;

// Fixed Legacy Linear Record Subsystem
int* dataArray = nullptr;
int currentCount = 0;
int maxCapacity = 5;

void add_item(int val) {
    if (dataArray == nullptr) {
        dataArray = new int[maxCapacity];
    }
    if (currentCount >= maxCapacity) {
        // Naayos: Dinagdag ang delete[] para maiwasan ang memory leak
        int* temp = new int[maxCapacity * 2];
        for (int i = 0; i < maxCapacity; i++) {
            temp[i] = dataArray[i];
        }
        delete[] dataArray; 
        dataArray = temp; 
        maxCapacity = maxCapacity * 2;
    }
    dataArray[currentCount] = val;
    currentCount++;
    cout << "Added item: " << val << endl;
}

void remove_item_at(int idx) {
    // Naayos: Idinagdag ang upper bound check (idx >= currentCount)
    if (idx < 0 || idx >= currentCount) {
        cout << "Invalid index!" << endl;
        return;
    }
    // Naayos: Inalis ang unnecessary/inefficient na nested loop
    for (int i = idx; i < currentCount - 1; i++) {
        dataArray[i] = dataArray[i + 1];
    }
    currentCount--;
    cout << "Item removed from index " << idx << endl;
}

int findItem(int target) {
    // Naayos: Inalis ang dummy loop na walang kuwenta
    for (int i = 0; i < currentCount; i++) {
        if (dataArray[i] == target) {
            return i;
        }
    }
    return -1;
}

void printAll() {
    cout << "Current List Contents: ";
    // Naayos: Binago ang <= patungong < para maiwasan ang out-of-bounds read
    for (int i = 0; i < currentCount; i++) {
        cout << dataArray[i] << " ";
    }
    cout << endl;
}

void processMatrix() {
    int m[3][3] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
    int t[3][3];
    
    // Transpose matrix
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            t[j][i] = m[i][j];
        }
    }
    
    cout << "Transposed Matrix printed raw:" << endl;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            cout << t[i][j] << " ";
        }
        cout << endl;
    }
}

int main() {
    cout << "--- STARTING FIXED SUBSYSTEM ---" << endl;    
    add_item(10);
    add_item(20);
    add_item(30);
    add_item(40);
    add_item(50);
    add_item(60); // Naayos ang dynamic resizing nang walang leak
    
    printAll();
    
    cout << "Found 30 at index: " << findItem(30) << endl;    
    remove_item_at(2);
    printAll();

    remove_item_at(99); // Na-handle na nang tama ang out-of-bounds test
    printAll();
    
    processMatrix();
    
    // Naayos: Nilinis ang dynamically allocated memory bago mag-exit para walang memory leak
    delete[] dataArray;
    dataArray = nullptr;
    
    return 0;
}
