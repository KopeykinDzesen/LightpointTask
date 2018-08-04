public class CandidatesPageController {

	public String clientFirstName { get; set; }
	public String clientLastName { get; set; }
	public String clientLogin { get; set; }
	public String clientRole { get; set; }
	public String clientEmail { get; set; }

	public String client { get; set; }

	public List<Candidate__c> allCandidates { get; set; }
	public List<Schema.FieldSetMember> candidatesFieldsName { get; set; }

	public String idEditCandidate { get; set; }

	public String test { get; set; }

	public CandidatesPageController() {

		initClient();

		this.allCandidates = new List<Candidate__c>();
		this.candidatesFieldsName = new List<Schema.FieldSetMember>();
		this.idEditCandidate = '';

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

	public void candidatesShow() {

		candidatesFieldsName = SObjectType.Candidate__c.FieldSets.DefaultFieldSet.getFields();

		String query = 'SELECT Id ';
		for (Schema.FieldSetMember f : candidatesFieldsName) {
			query += ', ' + f.getFieldPath();
		}
		query += ' FROM Candidate__c ';

		allCandidates = (List<Candidate__c>)Database.query(query);

    }

	public PageReference clientsShow() {
		Cache.Session.put('local.X1234567890.client', clientLogin);
		PageReference clientsPage = Page.ClientsPageForManager;
      	clientsPage.setRedirect(true);
		return clientsPage;
	}

	public PageReference employeesShow() {
		Cache.Session.put('local.X1234567890.client', clientLogin);
		PageReference employeesPage = Page.EmployeesPageForManager;
      	employeesPage.setRedirect(true);
		return employeesPage;
	}

	public PageReference createCandidate() {
		Cache.Session.put('local.X1234567890.client', clientLogin);
		PageReference createCandidatePage = Page.CreateCandidate;
      	createCandidatePage.setRedirect(true);
		return createCandidatePage;
	}

	public PageReference editCandidate() {
		test = idEditCandidate;
		Cache.Session.put('local.X1234567890.idEditCandidate', idEditCandidate);
		PageReference candidateViewPage = Page.CandidateViewPageForManager;
      	candidateViewPage.setRedirect(true);
		return candidateViewPage;
	}

}