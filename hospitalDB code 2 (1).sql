CREATE DATABASE IF NOT EXISTS SecureHospitalDB;

USE SecureHospitalDB;

CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    date_of_birth DATE,
    phone VARCHAR(20),
    address VARCHAR(255),
    medical_history VARBINARY(255),
    diagnosis VARBINARY(255)
);
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    specialty VARCHAR(100),
    email VARCHAR(100)
);
CREATE TABLE Billing (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    amount DECIMAL(10,2),
    payment_status VARCHAR(50),

    FOREIGN KEY (patient_id)
    REFERENCES Patients(patient_id)
);
CREATE TABLE Audit_Logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_role VARCHAR(50),
    action_done VARCHAR(255),
    patient_id INT,
    access_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO Doctors (full_name, specialty, email)
VALUES
('Ahmed Ali', 'Cardiology', 'ahmed@hospital.com'),
('Sara Hassan', 'Dermatology', 'sara@hospital.com');
INSERT INTO Patients
(full_name, date_of_birth, phone, address, medical_history, diagnosis)
VALUES
(
 'Mona Khalid',
 '2001-03-15',
 '0551234567',
 'Dammam',
 AES_ENCRYPT('Patient has asthma history', 'hospital_key'),
 AES_ENCRYPT('Mild asthma', 'hospital_key')
);
SELECT * FROM Patients;
SELECT 
patient_id,
full_name,

CAST(AES_DECRYPT(medical_history, 'hospital_key') AS CHAR) AS medical_history,

CAST(AES_DECRYPT(diagnosis, 'hospital_key') AS CHAR) AS diagnosis

FROM Patients;
INSERT INTO Audit_Logs
(user_role, action_done, patient_id)
VALUES
('Doctor', 'Viewed patient medical record', 1);
SELECT * FROM Audit_Logs;
-- Create Doctor Role/User
CREATE USER 'doctor_user'@'localhost'
IDENTIFIED BY 'doctor123';

-- Create Receptionist Role/User
CREATE USER 'reception_user'@'localhost'
IDENTIFIED BY 'reception123';

-- Grant permissions to Doctor
GRANT SELECT ON SecureHospitalDB.Patients
TO 'doctor_user'@'localhost';

-- Grant limited permissions to Receptionist
GRANT SELECT (patient_id, full_name, phone, address)
ON SecureHospitalDB.Patients
TO 'reception_user'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;