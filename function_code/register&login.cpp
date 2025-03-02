#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include "management_system.h"

using namespace std;

enum class Gender {
    MALE, FEMALE
};

class User {
    public:
        string id;
        string name;
        int age;
        int deposit;
        string address;
        Gender gender;
        string phone_number;
        string account;
        string password;
        bool usability = true;
    
        User() {
    
        }
    
        User(string id, string name, int age, int deposit, string address, Gender gender, string phone_number, string account, string password) {
            this->id = id;
            this->name = name;
            this->age = age;
            this->deposit = deposit;
            this->address = address;
            this->gender = gender;
            this->phone_number = phone_number;
            this->account = account;
            this->password = password;
        }
    
        void Check_Deposit() {
            if (deposit < 0) {
                cout << "Insufficient balance." << endl;
            }
        }
    
        void setId(string id) {
            this->id = id;
        }
    
        string getId() {
            return id;
        }
    
        void setName(string name) {
            this->name = name;
        }
    
        string getName() {
            return name;
        }
    
        void setAge(int age) {
            this->age = age;
        }
    
        int getAge() {
            return age;
        }
    
        void setDeposit(int deposit) {
            this->deposit = deposit;
        }
    
        int getDeposit() {
            return deposit;
        }
    
        void setAddress(string address) {
            this->address = address;
        }
    
        string getAddress() {
            return address;
        }
    
        void setGender(Gender gender) {
            this->gender = gender;
        }
    
        Gender getGender() {
            return gender;
        }
    
        void setPhone_number(string phone_number) {
            this->phone_number = phone_number;
        }
    
        string getPhone_number() {
            return phone_number;
        }
    
        void setAccount(string account) {
            this->account = account;
        }
    
        string getAccount() {
            return account;
        }
    
        void setPassword(string password) {
            this->password = password;
        }
    
        string getPassword() {
            return password;
        }
    
        void Fresh_Usability() {
            usability = true;
        }
    
        void Lock_Account() {
            usability = false;
        }
    };
    
    class Book {
    public:
        string id_book;
        string title;
        string author;
        string intro;
        string category;
        int deposit;
        bool isborrow = false;
    
        void setid_book(string id_book) {
            this->id_book = id_book;
        }
    
        string getid_book() {
            return id_book;
        }
    
        void settitle(string title) {
            this->title = title;
        }
    
        string gettitle() {
            return title;
        }
    
        void setAuthor(string author) {
            this->author = author;
        }
    
        string getAuthor() {
            return author;
        }
    
        void setIntro(string intro) {
            this->intro = intro;
        }
        string getIntro() {
            return intro;
        }
    
        void setCategory(string category) {
            this->category = category;
        }
    
        string getCategory() {
            return category;
        }
    
        void setDeposit(int deposit) {
            this->deposit = deposit;
        }
    
        int getDeposit() {
            return deposit;
        }
    
        void Borrowed() {
            isborrow = true;
        }
    
        void Returned() {
            isborrow = false;
        }
    };

bool registerUser(vector<User>& users) {
    string newAccount, newPassword;
    cout << "Please enter a new username: ";
    cin >> newAccount;

    for (auto user : users) {
        if (user.getAccount() == newAccount) {
            cout << "This username already exists. Please choose another one." << endl;
            return false;
        }
    }

    cout << "Please enter a password: ";
    cin >> newPassword;

    string newId = to_string(users.size() + 1);
    string newName = "NewUser";
    int newAge = 20;
    int newDeposit = 0;
    string newAddress = "Unknown";
    Gender newGender = Gender::MALE;

    users.emplace_back(newId, newName, newAge, newDeposit, newAddress, newGender, "", newAccount, newPassword);
    saveUsersToFile(users);
    cout << "Registration successful!" << endl;
    return true;
}

bool login(vector<User>& users, string& input_username) {
    string input_password;
    cout << "Please enter your username: ";
    cin >> input_username;
    cout << "Please enter your password: ";
    cin >> input_password;

    for (auto& user : users) {
        if (user.getAccount() == input_username && user.getPassword() == input_password && user.usability) {
            return true;
        }
    }
    return false;
}
int main() {

    return 0;
}