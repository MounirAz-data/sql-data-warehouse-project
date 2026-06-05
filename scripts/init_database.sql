/* 
===================================================
Create Database and Schemas 
===================================================
Script purpose :
	
	Since I'm focusing on creating the Database and using the medallion architecure
	the script sets up three schemas within the database :
	3 layers 'Bronze', 'Silver' and 'Gold'.

*/

--create database 'datawarehouse'

	USE master;
	GO

	CREATE DATABASE Datawarehouse;
	GO

	USE Datawarehouse;
	GO

-- Create Schemas for each layer Bronze,Silver,Gold

	CREATE SCHEMA Bronze;

	Go

	CREATE SCHEMA Silver;

	Go

	CREATE SCHEMA Gold;

	Go
