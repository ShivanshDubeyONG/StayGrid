# StayGrid

### A modern hotel discovery and booking platform built with Django and PostgreSQL.

StayGrid is a full-stack hotel booking application designed to provide a clean, premium experience for discovering hotels, comparing stays, checking room availability, and making bookings.

The platform supports room-level inventory, guest reviews, dynamic Stay Scores, user authentication, hotel management, and PostgreSQL-backed booking data.

🌐 **[LIVE DEMO](https://staygrid-z1xq.onrender.com)**
---





<img width="1482" height="967" alt="image" src="https://github.com/user-attachments/assets/3e50d56e-740f-4e9c-83f0-dca34578464f" />

<img width="1492" height="967" alt="image" src="https://github.com/user-attachments/assets/9e97369b-9195-4094-b4e3-f9c497f3c2b5" />

<img width="1567" height="926" alt="image" src="https://github.com/user-attachments/assets/096c1610-85d6-42a7-8f49-a2bc0a6d1dcf" />

<img width="1497" height="966" alt="image" src="https://github.com/user-attachments/assets/ba2c572d-3aa0-4f30-98e1-c498839fe6cd" />

<img width="1492" height="972" alt="image" src="https://github.com/user-attachments/assets/bfb55e94-0aed-4c1e-a3d3-05f193df39d8" />


## ✨ Features

### 🏨 Hotel Discovery

- Browse active hotels
- Search hotels by destination
- Filter hotels by price and rating
- View hotel descriptions and pricing
- Premium responsive hotel cards
- Dynamic Stay Score for comparing properties

### 🛏️ Room-Level Booking

- View available rooms for each hotel
- Multiple room types:
  - Standard
  - Deluxe
  - Suite
- Room-specific pricing
- Guest count selection
- Check-in and check-out date selection
- Booking validation
- Booking confirmation flow
- Cancel bookings
- View personal booking history

### ⭐ Reviews & Ratings

- Authenticated users can review hotels
- 1–5 star ratings
- Written guest reviews
- Average hotel rating calculation
- Review count contributes to the Stay Score

### 📊 Stay Score

StayGrid uses a custom scoring system to help users compare properties.

The score considers:

- Hotel star rating
- Guest review rating
- Number of reviews
- Price value

The final score is normalized to a scale of **0–100**.

### 👤 User Authentication

- User registration
- Login
- Logout
- Protected booking functionality
- User profile
- Personal booking history

### 🧑‍💼 Hotel Management

Hotel owners/vendors can:

- Create hotels
- Edit hotel information
- Manage rooms
- Add rooms
- Edit room details
- Delete rooms
- Activate/deactivate hotels and rooms

### 📱 Responsive UI

The interface is designed for:

- Desktop
- Tablet
- Mobile

The frontend uses a clean editorial-style design with responsive layouts and reusable components.

---

## 🛠️ Tech Stack

### Backend

- Python
- Django 5
- Django ORM
- Gunicorn

### Database

- PostgreSQL

### Frontend

- HTML5
- CSS3
- JavaScript
- Django Templates

### Production

- Render
- WhiteNoise
- Gunicorn
- PostgreSQL

### Other

- Pillow
- python-dotenv
- dj-database-url

---

## 🏗️ Project Structure

```text
StayGrid/
│
├── config/
│   ├── settings.py
│   ├── urls.py
│   ├── wsgi.py
│   └── ...
│
├── hotels/
│   ├── migrations/
│   ├── admin.py
│   ├── forms.py
│   ├── models.py
│   ├── urls.py
│   └── views.py
│
├── users/
│   ├── migrations/
│   ├── forms.py
│   ├── models.py
│   ├── urls.py
│   └── views.py
│
├── vendors/
│   ├── migrations/
│   ├── models.py
│   └── ...
│
├── templates/
│   ├── components/
│   ├── hotels/
│   ├── users/
│   └── ...
│
├── static/
│   ├── css/
│   ├── js/
│   └── images/
│
├── media/
│
├── manage.py
├── requirements.txt
├── .gitignore
└── README.md
