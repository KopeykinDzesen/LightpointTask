public class EmployeesPageController {

	public String clientFirstName { get; set; }
	public String clientLastName { get; set; }
	public String clientLogin { get; set; }
	public String clientRole { get; set; }
	public String clientEmail { get; set; }

	public String client { get; set; }

	public String arrayCheckBoxRole { get; set; }

	public List<Employee__c> allEmployees { get; set; }
	public List<Employee__c> employeesWithFilter { get; set; }
	public List<Schema.FieldSetMember> employeesFieldsName { get; set; }

	public String test { get; set; }

	public EmployeesPageController() {

		initClient();

		this.allEmployees = new List<Employee__c>();
		this.employeesWithFilter = new List<Employee__c>();
		this.employeesFieldsName = new List<Schema.FieldSetMember>();
		this.arrayCheckBoxRole = '';

		this.test = 'abrakadabra';

	}

	public void initClient() {

		this.clientLogin = (String)Cache.Session.get('local.X1234567890.client');
		test = clientLogin;

		List<Client__c> clts = (List<Client__c>)Database.query('SELECT Login__c, Employee__c FROM Client__c ' +
					+ ' WHERE Login__c = :clientLogin LIMIT 1');
		if (clts.size() == 0) {
			return;
		}
		Client__c clt = clts[0];
		Id cltEmpId = clt.Employee__c;
		List<Employee__c> empls = (List<Employee__c>)Database.query('SELECT FirstName__c, LastName__c, Role__c, Email__c ' +
					+ ' FROM Employee__c WHERE Id = :cltEmpId LIMIT 1');
		Employee__c emple = empls[0];

		this.clientFirstName = emple.FirstName__c;
		this.clientLastName = emple.LastName__c;
		this.clientLogin = clt.Login__c;
		this.clientRole = emple.Role__c;
		this.clientEmail = emple.Email__c;

		if (clientRole != 'Manager') {
			return;
		}

		Map<String, String> clientMap = new Map<String, String>();
		clientMap.put('FirstName', clientFirstName);
		clientMap.put('LastName', clientLastName);
		clientMap.put('Login', clientLogin);
		clientMap.put('Role', clientRole);
		clientMap.put('Email', clientEmail);

		client = JSON.serialize(clientMap);

	}

	public PageReference exitToLoginPage() {
		Cache.Session.put('local.X1234567890.client', '');
		return Page.LoginPage;
	}

	public void employeesShow() {

		employeesFieldsName = SObjectType.Employee__c.FieldSets.DefaultFieldSet.getFields();

		if (!allEmployees.isEmpty()) {

			employeesWithFilter.clear();
			List<Integer> arrayRoles = (List<Integer>)System.JSON.deserialize(arrayCheckBoxRole, List<Integer>.class);

			test = arrayCheckBoxRole;

			if (arrayRoles.contains(1)) {
				test += '1';
				for (Employee__c emple : allEmployees) {
					if (emple.Role__c == 'Manager') {
						employeesWithFilter.add(emple);
					}
				}
			}

			if (arrayRoles.contains(2)) {
				test += '2';
				for (Employee__c emple : allEmployees) {
					if (emple.Role__c == 'HR') {
						employeesWithFilter.add(emple);
					}
				}
			}

			if (arrayRoles.contains(3)) {
				test += '3';
				for (Employee__c emple : allEmployees) {
					if (emple.Role__c == 'Interviewer') {
						employeesWithFilter.add(emple);
					}
				}
			}

			return;
		}

		String query = 'SELECT Id';
		//String query = 'SELECT Id ';
		for (Schema.FieldSetMember f : employeesFieldsName) {
			query += ', ' + f.getFieldPath();
		}
		if (!query.contains('Role__c')) {
			query = query.substring(0, 8) + ', Role__c' + query.substring(8);
		}
		query += ' FROM Employee__c ';

		test = query;

		allEmployees = (List<Employee__c>)Database.query(query);
		employeesWithFilter.addAll(allEmployees);

    }

	public PageReference candidatesShow() {
		Cache.Session.put('local.X1234567890.client', clientLogin);
		PageReference candidatePage = Page.CandidatesPageForManager;
      	candidatePage.setRedirect(true);
		return candidatePage;
	}

	public PageReference clientsShow() {
		Cache.Session.put('local.X1234567890.client', clientLogin);
		PageReference clientsPage = Page.ClientsPageForManager;
      	clientsPage.setRedirect(true);
		return clientsPage;
	}

}