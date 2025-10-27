# 🍽️ Restaurant Database Project
This project is a web-based demo **Restaurant Database** application that allows users to browse, search, and manage restaurant information. It was built to show **full-stack development** using React for the frontend, Flask for the backend, and MySQL for the database.  

## 🌐 Live Demo
https://19ndc2.github.io/Demo_Restaurant_Database/#/

## 📲 Features:
- Add new customers to the database
- Get pre-existing customer information
- Search all orders by date
- See all shifts scheduled by each restaurant

## 🔨 Architecture
- **Frontend**: React.js, React Router for navigation 
- **Backend**: Flask REST API serving restaurant data  
- **Database**: MySQL (or whichever you’re using)  
- **CORS enabled** for cross-origin frontend-backend communication  

## Setup

### Clone repository
```bash
git clone https://github.com/19ndc2/Demo_Restaurant_Database.git
```

### Local Frontend setup
```bash
cd Frontend/restaurant-frontend
npm install
npm start
```

### Local Backend setup
```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
./run.sh
```
