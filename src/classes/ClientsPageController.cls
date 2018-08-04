public class ClientsPageController {

	public String clientFirstName { get; set; }
	public String clientLastName { get; set; }
	public String clientLogin { get; set; }
	public String clientRole { get; set; }
	public String clientEmail { get; set; }

	public String client { get; set; }

	public String arrayCheckBoxRole { get; set; }

	public List<Client__c> allClients { get; set; }
	public List<Client__c> clientsWithFilter { get; set; }
	public List<Schema.FieldSetMember> clientsFieldsName { get; set; }

	public String test { get; set; }

	public ClientsPageController() {

		initClient();

		this.allClients = new List<Client__c>();
		this.clientsWithFilter = new List<Client__c>();
		this.clientsFieldsName = new List<Schema.FieldSetMember>();
		this.arrayCheckBoxRole = '';

		//this.test = 'abrakadabra';

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
		PageReference loginPage = Page.LoginPage;
      	loginPage.setRedirect(true);
		return loginPage;
	}

	public void clientsShow() {

		clientsFieldsName = SObjectType.Client__c.FieldSets.DefaultFieldSet.getFields();

		if (!allClients.isEmpty()) {

			clientsWithFilter.clear();
			List<Integer> arrayRoles = (List<Integer>)System.JSON.deserialize(arrayCheckBoxRole, List<Integer>.class);

			test = arrayCheckBoxRole;

			if (arrayRoles.contains(1)) {
				test += '1';
				for (Client__c clt : allClients) {
					if (clt.Employee__r.Role__c == 'Manager') {
						clientsWithFilter.add(clt);
					}
				}
			}

			if (arrayRoles.contains(2)) {
				test += '2';
				for (Client__c clt : allClients) {
					if (clt.Employee__r.Role__c == 'HR') {
						clientsWithFilter.add(clt);
					}
				}
			}

			if (arrayRoles.contains(3)) {
				test += '3';
				for (Client__c clt : allClients) {
					if (clt.Employee__r.Role__c == 'Interviewer') {
						clientsWithFilter.add(clt);
					}
				}
			}

			return;
		}

		String query = 'SELECT Id, Employee__r.Role__c ';
		//String query = 'SELECT Id ';
		for (Schema.FieldSetMember f : clientsFieldsName) {
			query += ', ' + f.getFieldPath();
		}
		query += ' FROM Client__c ';

		allClients = (List<Client__c>)Database.query(query);
		clientsWithFilter.addAll(allClients);

    }

	public PageReference candidatesShow() {
		Cache.Session.put('local.X1234567890.client', clientLogin);
		PageReference candidatesPage = Page.CandidatesPageForManager;
      	candidatesPage.setRedirect(true);
		return candidatesPage;
	}

	public PageReference employeesShow() {
		Cache.Session.put('local.X1234567890.client', clientLogin);
		PageReference employeesPage = Page.EmployeesPageForManager;
      	employeesPage.setRedirect(true);
		return employeesPage;
	}

}