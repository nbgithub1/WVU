#This script will create the user account records for the client machine's windows user name
# This is required for the openPDC to access the openpdc configuration database from the client machine.

Use openpdc;
#name - Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon - AutoLogonSID from client machine
select @WinUserName := 'X-X-X-XX-XXXXXXXX-XXXXXXX-XXXXX-XXXX';
#select @WinUserName;
#select * from device where Name = 'Shelby'
select @DeviceNodeId := NodeID from device where Name = 'Shelby';
#select @DeviceNodeId;
select @ClientMachineUser := 'XXXX\\XXXXX';
#select @ClientMachineUser;
select @ClienMachineUserIP := 'XX@XXX.XXX.X.XX';
select @RoleForAccess := 'Administrator';
#delete if exists
delete from useraccount where Name =   @WinUserName;
#insert a new user for the client machine's windows user Id , ID- GUID - xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx .
INSERT INTO  useraccount
(`ID`,
`Name`,
`Password`,
`FirstName`,
`LastName`,
`DefaultNodeID`,
`Phone`,
`Email`,
`LockedOut`,
`UseADAuthentication`,
`ChangePasswordOn`,
`CreatedOn`,
`CreatedBy`,
`UpdatedOn`,
`UpdatedBy`)

select    
uuid()
,@WinUserName
,null
,null
,null
,@DeviceNodeId
,null
,null
,0
,1
,now()
,now()
,@ClientMachineUser
,now()
,@ClientMachineUser
;
 
select * from     useraccount;

#Delete role if exists
delete from applicationrole where Name in('Administrator','Editor','Viewer');
#Insert all roles for windows user for the device node
INSERT INTO `openpdc`.`applicationrole`
(`ID`,
`Name`,
`Description`,
`NodeID`,
`CreatedOn`,
`CreatedBy`,
`UpdatedOn`,
`UpdatedBy`)
VALUES
(   
uuid()
,'Administrator'
,'Administrator Role'
,@DeviceNodeId
,now()
,@ClienMachineUserIP
,now()
,@ClienMachineUserIP
);

INSERT INTO `openpdc`.`applicationrole`
(`ID`,
`Name`,
`Description`,
`NodeID`,
`CreatedOn`,
`CreatedBy`,
`UpdatedOn`,
`UpdatedBy`)
VALUES
(   
uuid()
,'Editor'
,'Editor Role'
,@DeviceNodeId
,now()
,@ClienMachineUserIP
,now()
,@ClienMachineUserIP
);

INSERT INTO `openpdc`.`applicationrole`
(`ID`,
`Name`,
`Description`,
`NodeID`,
`CreatedOn`,
`CreatedBy`,
`UpdatedOn`,
`UpdatedBy`)
VALUES
(   
uuid()
,'Viewer'
,'Viewer Role'
,@DeviceNodeId
,now()
,@ClienMachineUserIP
,now()
,@ClienMachineUserIP
);

#insert a record to applicationroleuseraccount
INSERT INTO `openpdc`.`applicationroleuseraccount`
(`ApplicationRoleID`,
`UserAccountID`)
select r.ID,a.ID from useraccount a join applicationrole r on a.DefaultNodeID = r.NodeID 
where a.Name = @WinUserName and r.Name = @RoleForAccess
;

select * from     applicationroleuseraccount;
 
