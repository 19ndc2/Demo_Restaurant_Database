import React from 'react';
import { Link } from 'react-router-dom'; // for navigation between pages

function HomePage() {
  return (
    <div className="container text-center mt-5">
        <div className="card shadow-lg p-4 border-0">
            <h1 className = "mb-3 text-primary">Demo Restaurant Database</h1>
            <p className = "lead mb-4">Hello! Thanks for visiting</p>
            <nav>
                <ul className="list-unstyled d-flex flex-column align-items-center gap-3">
                    <li><Link to="/orders" className="btn btn-outline-primary btn-lg">Orders</Link></li>
                    <li><Link to="/new-customer" className="btn btn-outline-primary btn-lg">Customers</Link></li>
                    <li><Link to="/shift-schedule" className="btn btn-outline-primary btn-lg">Shift Schedules</Link></li>
                </ul>
            </nav>
        </div>
    </div>
  );
}

export default HomePage;