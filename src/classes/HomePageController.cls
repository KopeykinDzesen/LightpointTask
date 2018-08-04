public class HomePageController {

	public String clientFirstName { get; set; }
	public String clientLastName { get; set; }
	public String clientLogin { get; set; }
	public String clientRole { get; set; }
	public String clientEmail { get; set; }

	public String client { get; set; }

	public List<Client__c> allClients { get; set; }
	public List<Schema.FieldSetMember> clientsFieldsName { get; set; }

	public String test { get; set; }

	public HomePageController() {

		initClient();

		this.allClients = new List<Client__c>();
		this.clientsFieldsName = new List<Schema.FieldSetMember>();

		this.test = 'abrakadabra';

	}

	public PageReference initClient() {

		this.clientLogin = (String)Cache.Session.get('local.X1234567890.client');

		if (clientLogin == '') {
			return Page.MainPage;
		}

		List<Client__c> clts = (List<Client__c>)Database.query('SELECT Login__c, Employee__c FROM Client__c ' +
					+ ' WHERE Login__c = :clientLogin LIMIT 1');
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

		return null;

	}

	public PageReference exitToLoginPage() {
		Cache.Session.put('local.X1234567890.client', '');
		return Page.MainPage;
	}

	public void clientsShow() {

		clientsFieldsName = SObjectType.Client__c.FieldSets.DefaultFieldSet.getFields();

		String query = 'SELECT Id ';
		for (Schema.FieldSetMember f : clientsFieldsName) {
			query += ', ' + f.getFieldPath();
		}
		query += ' FROM Client__c ';

		allClients = (List<Client__c>)Database.query(query);

		for (Client__c c : allClients) {
			test += c.Login__c;
		}

    }

	public void candidatesShow() {
		
	}

	public void employeesShow() {
		
	}

}