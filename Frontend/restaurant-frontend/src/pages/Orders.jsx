import React, { useState } from 'react';
import { Link } from 'react-router-dom'; // for navigation between pages


function Orders() {
    const [date, setDate] = useState('');
    const [orders, setOrders] = useState([]);
    const [message, setMessage] = useState('');
    const [loading, setLoading] = useState(false);

    //update date on form change
    const handleChange = (e) => {
        setDate(e.target.value);
    };

    //hangle date submission
    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!date) return;

        setLoading(true); //start loading
        try {
          const res = await fetch(`http://127.0.0.1:5000/order/${date}`);
          const data = await res.json();
    
          if (data.message) {
            setOrders([]);
            setMessage(data.message);
          } else {
            setOrders(data);
            setMessage('');
          }
        } catch (error) {
          console.error('Error fetching orders:', error);
          setMessage('Error fetching orders');
          setOrders([]);
        } finally {
            setLoading(false);
        }
      };

    //Make sure date is valid format
    const isValidDate = (dateString) => {
        const regex = /^\d{4}-\d{2}-\d{2}$/;
        if (!regex.test(dateString)) return false;
      
        const date = new Date(dateString);
        const timestamp = date.getTime();
        if (isNaN(timestamp)) return false;
      
        const [year, month, day] = dateString.split("-").map(Number);
        return (
          date.getUTCFullYear() === year &&
          date.getUTCMonth() + 1 === month &&
          date.getUTCDate() === day
        );
      };

    return (
        <div className="container text-center mt-5">
            <div className="card shadow-lg p-4 border-0 mx-auto">
                <h1 className = "mb-3 text-primary">Add Order Page</h1>


                <h2 className="h4 text-secondary mb-3 fw-semibold">Orders on date</h2>
                <form onSubmit={handleSubmit} className="text-start row justify-content-center">

                    <div className="col-md-8 col-lg-6">
                        <label className="form-label fw-semibold" >Search orders on date (try 2022-12-05)</label>
                        <input name="date" type="text" value={date} onChange={handleChange} placeholder="yyyy-mm-dd" maxLength={10} className="form-control"></input>
                        <button 
                            type="submit" 
                            className="btn btn-primary w-100 mt-3"
                            disabled={!isValidDate(date) || loading}
                        >
                            {loading ? (
                            <>
                                <span className="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
                                Loading...
                            </>
                            ) : (
                                "Submit"
                            )}
                        </button>

                        {message && (
                        <div className="alert alert-warning text-center mt-3" role="alert">
                        {message}
                        </div>
                        )}
                    </div>
                </form>

                {orders.length > 0 && (
                    <div className="table-responsive">
                        <table className="table table-striped table-bordered mt-4">
                            <thead className="table-light">
                                <tr>
                                    <th>Order ID</th>
                                    <th>Customer Name</th>
                                    <th>Customer Email</th>
                                    <th>Restaurant</th>
                                    <th>Items Ordered</th>
                                    <th>Order Date</th>
                                    <th>Total</th>
                                    <th>Tip</th>
                                </tr>
                            </thead>
                            <tbody>
                            {orders.map((order) => (
                                <tr key={order.orid}>
                                <td>{order.orid}</td>
                                <td>{order.firstName} {order.lastName}</td>
                                <td>{order.email}</td>
                                <td>{order.resname}</td>
                                <td>{order.items}</td>
                                <td>{new Date(order.orderDate).toISOString().split('T')[0]}</td>
                                <td>{order.price}</td>
                                <td>{order.tip}</td>
                                </tr>
                            ))}
                            </tbody>
                        </table>
                    </div>
                )}
                
                <div>
                    <Link to="/" className="btn btn-outline-secondary text-decoration-none mt-3">home</Link>
                </div>
            </div>
        </div>
    );
}


export default Orders;