-- Create Users table for authentication
-- Create Hospitals table
Create database hospital_management_system;
use hospital_management_system;
CREATE TABLE hospitals (
    hospital_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    contact_number VARCHAR(20),
    total_beds INT NOT NULL
);

-- Create Departments table
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    hospital_id INT REFERENCES hospitals(hospital_id),
    name VARCHAR(50) NOT NULL
);

-- Create Doctors table
CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    hospital_id INT REFERENCES hospitals(hospital_id),
    department_id INT REFERENCES departments(department_id),
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(50),
    contact_number VARCHAR(20)
);

-- Create Patients table
CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(10),
    contact_number VARCHAR(20),
    address TEXT
);

-- Create OPD_Appointments table
CREATE TABLE opd_appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    doctor_id INT REFERENCES doctors(doctor_id),
    hospital_id INT REFERENCES hospitals(hospital_id),
    appointment_datetime TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'Scheduled',
    priority INT DEFAULT 3,  -- 1: High, 2: Medium, 3: Low
    estimated_wait_time INT  -- in minutes
);

-- Create Beds table
CREATE TABLE beds (
    bed_id SERIAL PRIMARY KEY,
    hospital_id INT REFERENCES hospitals(hospital_id),
    department_id INT REFERENCES departments(department_id),
    bed_number VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'Available'  -- Available, Occupied, Maintenance
);

-- Create Admissions table
CREATE TABLE admissions (
    admission_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    bed_id INT REFERENCES beds(bed_id),
    doctor_id INT REFERENCES doctors(doctor_id),
    admission_datetime TIMESTAMP NOT NULL,
    discharge_datetime TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Active'  -- Active, Discharged
);

-- Create City_Wide_Status table for real-time updates
CREATE TABLE city_wide_status (
    status_id SERIAL PRIMARY KEY,
    hospital_id INT REFERENCES hospitals(hospital_id),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    available_beds INT,
    opd_wait_time INT,  -- Average wait time in minutes
    emergency_status VARCHAR(20)  -- Normal, High Alert, Critical
);
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,  -- 'patient', 'doctor', 'admin'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

-- Create UserProfiles table for additional user information
CREATE TABLE user_profiles (
    profile_id SERIAL PRIMARY KEY,
    user_id INT UNIQUE REFERENCES users(user_id),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone_number VARCHAR(20),
    address TEXT,
    date_of_birth DATE,
    gender VARCHAR(10)
);

-- Create OPD_Registrations table
CREATE TABLE opd_registrations (
    registration_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    hospital_id INT REFERENCES hospitals(hospital_id),
    department_id INT REFERENCES departments(department_id),
    registration_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    AadhaarNo int Not Null,
    symptoms TEXT,
    triage_level INT,  -- 1: Immediate, 2: Very Urgent, 3: Urgent, 4: Standard, 5: Non-Urgent
    status VARCHAR(20) DEFAULT 'Waiting'  -- 'Waiting', 'In Consultation', 'Completed'
);

-- Create a view to combine user and profile information
CREATE VIEW user_details AS
SELECT 
    u.user_id,
    u.username,
    u.email,
    u.role,
    up.first_name,
    up.last_name,
    up.phone_number,
    up.address,
    up.date_of_birth,
    up.gender
FROM users u
LEFT JOIN user_profiles up ON u.user_id = up.user_id;

-- Add foreign key to patients table to link with users
ALTER TABLE patients
ADD COLUMN user_id INT UNIQUE REFERENCES users(user_id);

-- Add foreign key to doctors table to link with users
ALTER TABLE doctors
ADD COLUMN user_id INT UNIQUE REFERENCES users(user_id);