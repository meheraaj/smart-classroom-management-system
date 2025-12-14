# 📘 Smart Classroom Management System (SCMS)

# [Live Demo](https://iiuc-scms.web.app/)

# Student Demo:
    Mail     :  C233267@gmail.com
    Password :  12345678

A modern **IoT-enabled Flutter + Firebase application** that automates classroom monitoring, student tracking, environmental alerts, and administrative controls.

Built using:

* **Flutter (Web + Mobile)**
* **Firebase Authentication**
* **Cloud Firestore**
* **Riverpod State Management**
* **Realtime IoT Sensor Integration**

---

## 🚀 Features

* Realtime classroom monitoring
* Fire, temperature & energy alerts
* Automatic student presence detection
* Teacher & student dashboards
* Admin panel for managing rooms & users
* Realtime device status display (fan/light)
* Flutter Web deployment with Firebase Hosting

---

## 📁 Firestore Structure

### **Collection: user**

Stores all students, teachers, and admins.

```json
{
  "id": "C233267",
  "name": "Meherajul",
  "dept": "CSE",
  "email": "student@example.com",
  "utype": "student",  
  "createdAt": "timestamp"
}
```

### **Collection: rooms**

```json
{
  "roomId": "cx404",
  "fire": 0,
  "temp": 28,
  "fan": 1,
  "light": 0,
  "teacherId": "T102",
  "students": {
    "C233267": {}
  }.
  humidity:55,
}
```

---

## 🧑‍🎓 User Roles

### **Student**

* View dashboard
* Check current room
* View alerts
* Browse rooms

### **Teacher**

* Teacher dashboard
* Room occupancy
* Alerts

### **Admin**

* Add Students / Teachers
* Add Rooms
* Modify Rooms
* View all users

---

## 🔥 Alert System Logic

Alerts trigger when:

* `fire == 1` → Fire alert
* `temp > 40` → Temperature alert
* Fan/light ON while no teacher or students → Energy alert

---

