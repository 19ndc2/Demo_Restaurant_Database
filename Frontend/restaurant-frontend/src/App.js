import React from 'react';
import { HashRouter as Router, Routes, Route } from 'react-router-dom';
import HomePage from './pages/HomePage.jsx';
import NewCustomer from './pages/NewCustomer.jsx';
import Orders from './pages/Orders.jsx';
import ShiftSchedule from './pages/ShiftSchedule.jsx';

function App() {
  console.log("running app function");
  return (
    <Router>
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/new-customer" element={<NewCustomer />} />
        <Route path="/orders" element={<Orders />} />
        <Route path="/shift-schedule" element={<ShiftSchedule />} />
      </Routes>
    </Router>
  );
}

export default App;