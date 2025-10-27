import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom'; // for navigation between pages


function ShiftSchedule() {
    const [shifts, setShifts] = useState([]);
    const [resnames, setResnames] = useState([]);
    const [selectedResname, setSelectedResname] = useState('');
    const [loading, setLoading] = useState(true); // track loading
    const [error, setError] = useState(null);     // track error

    // Fetch shifts and restaurant names
    useEffect(() => {
        const fetchData = async () => {
            setLoading(true);
            setError(null);
            try {
                const [resResnames, resShifts] = await Promise.all([
                    fetch('https://crusted-laura-unjudging.ngrok-free.dev/restaurant/get_resnames',{headers: {"ngrok-skip-browser-warning": "true"}}),
                    fetch('https://crusted-laura-unjudging.ngrok-free.dev/restaurant/get_shifts',{headers: {"ngrok-skip-browser-warning": "true"}})
                ]);

                if (!resResnames.ok) throw new Error(`Error fetching restaurants: ${resResnames.status}`);
                if (!resShifts.ok) throw new Error(`Error fetching shifts: ${resShifts.status}`);

                const resnamesData = await resResnames.json();
                const shiftsData = await resShifts.json();

                setResnames(resnamesData);
                setShifts(shiftsData);
            } catch (err) {
                console.error(err);
                setError('Failed to load initial data.');
            } finally {
                setLoading(false);
            }
        };

        fetchData();
    }, []);



    // filter shifts based on selected restaurant
    const filteredShifts = selectedResname
        ? shifts.filter(s => s.resname === selectedResname)
        : shifts;


    return (
    <div className="container text-center mt-5">
        <div className="card shadow-lg p-4 border-0 mx-auto">

            <h1 className = "mb-3 text-primary">Employee Shifts</h1>

            {loading && (
                <div className="text-center my-4">
                    <div className="spinner-border text-primary" role="status">
                        <span className="visually-hidden">Loading...</span>
                    </div>
                </div>
            )}

            {error && <div className="text-danger mb-3">{error}</div>}


            {!loading && !error && ( <>
                <h2 className="h4 text-secondary mb-3 fw-semibold">Select a Restaurant</h2>
                <div className="mb-4">
                    <select
                        value={selectedResname}
                        onChange={(e) => setSelectedResname(e.target.value)}
                        className="form-select w-50 mx-auto"
                    >
                        <option value="">All Restaurants</option>
                        {resnames.map((r, idx) => (
                        <option key={idx} value={r.resname}>
                            {r.resname}
                        </option>
                        ))}
                    </select>
                </div>

                {filteredShifts.length > 0 && (
                    <div className="table-responsive">
                        <table className="table table-striped table-bordered mt-3">
                            <thead className="table-light">
                            <tr>
                                <th>Full Name</th>
                                <th>Restaurant</th>
                                <th>Date</th>
                                <th>Position</th>
                                <th>Start Time</th>
                                <th>End Time</th>
                            </tr>
                            </thead>
                            <tbody>
                            {filteredShifts.map((s) => (
                                <tr key={`${s.id}-${s.sday}`}>
                                <td>{s.fullName}</td>
                                <td>{s.resname}</td>
                                <td>{s.role}</td>
                                <td>{s.sday}</td>
                                <td>{s.startTime}</td>
                                <td>{s.endTime}</td>
                                </tr>
                            ))}
                            </tbody>
                        </table>
                    </div>
                )}
            </>)}

            <div>
                <Link to="/" className="btn btn-outline-secondary text-decoration-none mt-3">home</Link>
            </div>
        </div>
      </div>
    );
}


export default ShiftSchedule;