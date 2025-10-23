import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom'; // for navigation between pages


function NewCustomer() {
    const [customers, setCustomers] = useState([]);
    const [selectedCustomer, setSelectedCustomer] = useState(null);
    const [loading, setLoading] = useState(false);


    const [loadingCustomers, setLoadingCustomers] = useState(false);
    const [errorCustomers, setErrorCustomers] = useState(null);


    const [formData, setFormData] = useState({
        firstName: '',
        lastName: '',
        email: '',
        phone: '',
        streetAddress: '',
        postalCode: '',
        province: ''
    });

    //get all customer names and emails
    useEffect(() => {
        // Fetch all customer names/emails for dropdown

        const fetchCustomers = async () => {
            setLoadingCustomers(true); // start loading
            setErrorCustomers(null); //clear previous errors 
            try {
                const res = await fetch('http://127.0.0.1:5000/get_customer_names');
                if (!res.ok) throw new Error(`Error ${res.status}`);
                const data = await res.json();
                setCustomers(data);           // set the fetched data
              } catch (err) {
                console.error('Failed to fetch customers:', err);
                setErrorCustomers('Failed to load customers'); // display an error
              } finally {
                setLoadingCustomers(false);    // stop loading
              }
        };
        fetchCustomers();

      }, []);

    //Get customer info based on email
    const handleSelect = async (e) => {
        const email = e.target.value;
        
        if (!email) {
            setSelectedCustomer(null);
            return;
        }
        setLoading(true); //show loading spinner

        const res = await fetch(`http://127.0.0.1:5000/customer/${email}`);
        const data = await res.json();
        setSelectedCustomer(data);
        
        setLoading(false); //hide loading spinner
    };



    //read form data
    const handleChange = e => {
        setFormData({ ...formData, [e.target.name]: e.target.value});
    };

    //post form data on button click
    const handleSubmit = async (e) => {
        e.preventDefault(); //prevent reload
        
        setLoading(true); //show loading spinner
        console.log("handling submit");
        try {
          const response = await fetch('http://127.0.0.1:5000/add_customer', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(formData)
          });
    
          const result = await response.json();
          alert(result.message);


          if (result.status === "success") {
            // Clear the form
            setFormData({
                firstName: '',
                lastName: '',
                email: '',
                phone: '',
                streetAddress: '',
                postalCode: '',
                province: ''
            });

            // Refetch the customer list to include the new customer
            const updatedList = await fetch('http://127.0.0.1:5000/get_customer_names')
                .then(res => res.json());
            setCustomers(updatedList);
            }
        } catch (error) {
            console.error('Error adding customer:', error);
        } finally {
            setLoading(false); //hide loading spinner
        }
      };


    //visible web page
    return (
        <div className="container text-center mt-5">
            <div className="card shadow-lg p-4 border-0 mx-auto" >
                <h1 className = "mb-3 text-primary">Customers</h1>

                {loadingCustomers && <div>Loading customers...</div>}
                {errorCustomers && <div className="text-danger">{errorCustomers}</div>}


                {!loadingCustomers && !errorCustomers && (<div>
                    <h2 className="h4 text-secondary mb-3 fw-semibold">Add Customer</h2>




                    <form onSubmit={handleSubmit} id="customerForm" className="text-start row justify-content-center">
                        <div className="col-md-8 col-lg-6">
                            <p className = "lead mb-4">Enter customer info:</p>

                            <div className="mb-3">
                                <label className="form-label fw-semibold">First Name</label>
                                <input name="firstName" type="text" maxLength={20} value={formData.firstName} onChange={handleChange} className="form-control"></input>
                            </div>

                            <div className="mb-3">
                                <label className="form-label fw-semibold">Last Name</label>
                                <input name="lastName" type="text" maxLength={20} value={formData.lastName} onChange={handleChange} className="form-control"></input>
                            </div>

                            <div className="mb-3">
                                <label className="form-label fw-semibold">Email</label>
                                <input name="email" type="text" maxLength={25} value={formData.email} onChange={handleChange} className="form-control"></input>
                            </div>

                            <div className="mb-3">
                                <label className="form-label fw-semibold">Phone Number</label>
                                <input name="phone" type="text" maxLength={10} value={formData.phone} onChange={handleChange} className="form-control"></input>
                            </div>

                            <div className="mb-3">
                                <label className="form-label fw-semibold">Street Address</label>
                                <input name="streetAddress" type="text" maxLength={25} value={formData.streetAddress} onChange={handleChange} className="form-control"></input>
                            </div>

                            <div className="mb-3">
                                <label className="form-label fw-semibold">Postal Code</label>
                                <input name="postalCode" type="text" maxLength={6} value={formData.postalCode} onChange={handleChange} className="form-control"></input>
                            </div>

                            <div className="mb-3">
                                <label className="form-label fw-semibold">Province</label>
                                <input name="province" type="text" maxLength={2} value={formData.province} onChange={handleChange} className="form-control"></input>
                            </div>

                            <br></br>
                            <button 
                                type="submit" 
                                className="btn btn-primary w-100 mt-3"
                                disabled= {
                                    !formData.firstName ||
                                    !formData.lastName ||
                                    !formData.email ||
                                    !formData.phone ||
                                    !formData.streetAddress ||
                                    !formData.postalCode ||
                                    !formData.province
                                }
                            >
                                {loading ? (
                                    <span className="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
                                ) : null}
                                Add Customer
                            </button>
                        </div>
                    </form> 

                    <hr className="my-4" />

                    <div className="row justify-content-center">
                        <div className="col-md-8 col-lg-6">
                            <h2 className="h4 text-secondary mb-3 fw-semibold">Customer Info</h2>
                            <div className="mb-3">
                                <select onChange={handleSelect} className="form-select">
                                    <option value="">Select a customer</option>
                                    {customers.map(c => (
                                    <option key={c.email} value={c.email}>{c.firstName} {c.lastName}</option>
                                    ))}
                                </select>
                            </div>

                            {loading && (
                                <div className="text-center my-3">
                                    <div className="spinner-border text-primary" role="status">
                                        <span className="visually-hidden">Loading...</span>
                                    </div>
                                </div>
                            )}

                            
                            {selectedCustomer && !loading && (
                                <div className="border rounded p-3 text-start bg-light">
                                    <h3 className="text-primary">{selectedCustomer.firstName} {selectedCustomer.lastName}</h3>
                                    <p><strong>Email:</strong> {selectedCustomer.email}</p>
                                    <p><strong>Phone:</strong> {selectedCustomer.phone}</p>
                                    <p><strong>Address:</strong> {selectedCustomer.streetAddress}, {selectedCustomer.postalCode}, {selectedCustomer.province}</p>
                                </div>
                            )}
                            

                            <div className="mt-4">
                                <Link className="btn btn-outline-secondary" to="/">home</Link>
                            </div>
                        </div>
                    </div>
                </div>)}


            </div>
        </div>
        
    );
}


export default NewCustomer;