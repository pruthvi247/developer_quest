[reference-blog](https://www.redhat.com/en/topics/security/what-is-ldap-authentication)
[ref-blog](https://www.cbtnuggets.com/blog/technology/networking/ldap-port-389-vs-636)
[OAuth2.0-Explained](https://www.youtube.com/watch?v=ZDuRmhLSLOY)
[JWT-Explained](https://www.youtube.com/watch?v=iB__rLXGsas)
[SAML-explained](https://www.youtube.com/watch?v=l-6QSEqDJPo)

## Why LDAP?

Enterprise network admins are typically managing thousands of users at a time. This means they are responsible for assigning access controls and policies based on a user’s role and access to files for everyday tasks, like a company intranet.

LDAP simplifies the user management process, saves network admins valuable time, and centralizes the authentication process.

The Lightweight Directory Access Protocol (LDAP) is a directory service protocol that runs on a layer above the TCP/IP stack

---

The main goal of LDAP is to communicate with, store, and extract objects (i.e. domains, users, groups, etc.) from AD(Active Directory) into a usable format for its own directory, located on the LDAP server. 

Think of it this way: AD is the largest library in the world, and you’re looking for a book with a title that mentions zombies. In the world of LDAP, the details of whether or not the book was published in the U.S., contains over 1,000 pages, or is a how-to guide on surviving the zombie apocalypse don’t matter–although they do help narrow down the options available. LDAP is the experienced librarian who knows exactly where to find all of the options that satisfy your request and verify you’ve found what you’re looking for.

## LDAP authentication process

The LDAP authentication process is a client-server model of authentication, and it consists of these key players: 

- **Directory System Agent (DSA):** a server running the LDAP on its network
- **Directory User Agent (DUA):** accesses DSAs as a client (ex. a user’s PC)
- **DN:** the distinguished name, which contains a path through the directory information tree (DIT) for LDAP to navigate through (ex. cn=Susan, ou=users, o=Company)
- **Relative Distinguished Name (RDN):** each component in the path within the DN (ex. cn=Susan)
- [**Application Programming Interface**](https://www.redhat.com/en/topics/api/what-are-application-programming-interfaces) **(API):** lets your product or service communicate with other products and services without having to know how they’re implemented

The process starts when a user tries to access an LDAP-enabled client program, like a business email application, on their PC. With LDAPv3, users will go through one of two possible user authentication methods: simple authentication, like SSO with login credentials, or SASL authentication, which binds the LDAP server to a program like Kerberos. The login attempt sends a request to authenticate the DN assigned to the user. The DN is sent through the client API or service that launches the DSA.

The client automatically binds to the DSA, and LDAP uses the DN to search for the matching object or set of objects against the records in the LDAP database. The RDNs in the DN are very important at this stage, as they provide each step in LDAP’s search through the DIT to find the individual. If the path is missing a connecting RDN on the backend, the result could turn up as invalid. In this case, the object LDAP is searching for is the individual user account (cn=Susan), and it can only validate the user if the account in the directory has the matching uid and userPassword. User groups are also identified as objects within the LDAP directory.

Once the user receives a response (valid or not valid), the client unbinds from the LDAP server. Authenticated users are then able to access the API and its services, including necessary files, user information, and other application data, based on the permissions granted by the system administrator.

### How Does LDAP Work?

LDAP works by sending standardized instructions from a client to an LDAP server. The goal is to access and interact with directory information. The client, such as a [Microsoft Teams](https://www.cbtnuggets.com/it-training/microsoft-teams/teams-administrator-associate) app, initiates a request. 

For instance, searching for "John Doe." The LDAP server maintains a Directory Information Tree (DIT), which represents the hierarchy of entries. Each entry has a Distinguished Name (DN), like:

CN=John Doe,OU=Users,DC=example,DC=com.

This DN uniquely identifies the entry's location. The LDAP server traverses the DIT efficiently to locate the requested user and associated information. It's not just about organization; it's about accessing and retrieving data within a structured framework.

The following are the most common procedures LDAP uses:

- **Bind**: verify the authenticity of a user against the LDAP server. For example, logging into the server at the start of your work day.
- **Search**: Search for specific entries based on some criteria. This could be searching for a user in Skype for business or the Outlook Address book.
- **Add**: Delete a user or roles to Active Directory
- **Modify**: Change aspects of an entity on Active Directory
- **Delete**: Delete a user from Active Directory

---

Think of it like a building with offices. These are all different pieces of the same puzzle: storing identities, verifying them, and granting access.

The Analogy: A Company Building
Imagine a big office building with a security desk, a filing cabinet, and a key card system.

LDAP — The Filing Cabinet
What it is: A protocol to store and look up user information (name, email, password, groups).

Like a giant phone book / address book for users and computers.
"Is there a user named john? What groups does he belong to?"
It doesn't log you in — it just stores data and lets you query it.
Real use: Apps ask LDAP: "Does this username/password combo exist?"

Active Directory (AD) — The Filing Cabinet + Security Desk
What it is: Microsoft's implementation of LDAP + a lot more.

AD uses LDAP under the hood, but adds:
User management (create/delete accounts)
Group policies (rules for computers)
Kerberos authentication (the actual login mechanism)
Think of it as LDAP + security guard + rule enforcement.
Relationship: AD ⊃ LDAP. All ADs speak LDAP, but not all LDAP servers are AD.

SAML — The Paper Passport
What it is: A standard for Single Sign-On (SSO) — proves who you are to one app using a trusted identity provider.

You log in once (e.g., your company SSO portal).
It gives you a signed XML "passport" (a SAML Assertion).
You show that passport to other apps — they trust it without asking for your password again.
Flow:

You → Google Workspace login → "Here's your signed passport"
You → Salesforce → shows passport → Salesforce trusts it → Access granted
Use case: Enterprise SSO. Logging into 10 internal tools with one company login.

OAuth 2.0 — The Valet Key
What it is: A standard for authorization — letting one app access your data on another app without sharing your password.

Not about who you are — about what an app is allowed to do.
Like giving a valet a limited key that only unlocks the car door, not the glove box.
Flow:

You → "Allow GitHub to post to your Twitter?"
Twitter → gives GitHub a limited access token
GitHub uses token → posts on your behalf (but can't change your password)
Use case: "Login with Google", letting Slack read your Google Calendar, etc.

Note: OAuth 2.0 is authorization, not authentication. OpenID Connect (OIDC) is built on top of OAuth 2.0 to add the "who are you" part.

Side-by-Side Summary
What it does Who uses it Think of it as
LDAP Store & query user data Backend systems The filing cabinet
Active Directory LDAP + Windows management Enterprises (Windows) Filing cabinet + security desk
SAML SSO via signed XML tokens Enterprise apps Paper passport
OAuth 2.0 Delegate access to resources Web/mobile apps Valet key

How they connect in real life

User logs in →
AD (stores the user) →
SAML (issues SSO token) →
Internal apps trust the token

User uses a 3rd-party app →
OAuth 2.0 (app gets limited access to your data)

---

Let me walk through each with a real-world scenario, showing exactly what gets passed at each step.

### 1. LDAP — Checking your company login

Scenario: You log into your company's internal HR portal.

You type: username=john, password=secret123

What happens behind the scenes:

1. Browser → HR App Server
   POST /login
   body: { username: "john", password: "secret123" }

2. HR App Server → LDAP Server (port 389)
   BIND request:
   {
   dn: "cn=john,ou=users,dc=company,dc=com",
   password: "secret123"
   }

3. LDAP Server checks its directory tree:
   dc=com
   └── dc=company
   └── ou=users
   └── cn=john ← found!
   uid: john
   password: [hashed]secret123 ← matches!

4. LDAP Server → HR App
   BIND response: "Success" (or "Invalid credentials")

5. HR App → Browser
   Set-Cookie: session_id=abc123
   Redirect to /dashboard

What's passed: Just a username + password, and a yes/no back. No tokens. LDAP is simple and direct.

### 2. Active Directory — Logging into Windows + network resources

Scenario: You press Ctrl+Alt+Delete on your Windows laptop at work.

You type: username=john@company.com, password=secret123

```

Step 1 — Your PC → Domain Controller (Kerberos AS)
  AS-REQ:
  {
    user: "john@company.com",
    timestamp: encrypted with john's password hash
  }

Step 2 — Domain Controller → Your PC
  AS-REP:
  {
    TGT (Ticket Granting Ticket): encrypted blob
    // This is your "master pass" — valid 8-10 hours
    // Only the DC can read it, you just carry it
  }

Step 3 — You open \\fileserver\shared (a network drive)
  Your PC → DC (Kerberos TGS):
  {
    TGT: [the blob from step 2],
    service: "fileserver"
  }

Step 4 — DC → Your PC
  Service Ticket:
  {
    ticket: encrypted with fileserver's secret
    // Only fileserver can decrypt this
  }

Step 5 — Your PC → File Server
  {
    service_ticket: [from step 4]
  }
  File Server decrypts it, sees "this is john, valid until 5pm"
  → Grants access, no password sent over the network!

```

Key insight: Your password is never sent after step 1. Everything is encrypted tickets. This is why AD is secure on corporate networks.

### 3. SAML — SSO for enterprise apps

Scenario: You're at Acme Corp. You open Salesforce for the first time in the morning.

Actors:

You (browser)
Salesforce (Service Provider / SP)
Okta (Identity Provider / IdP) — your company uses this

```
Step 1 — You visit: https://acme.salesforce.com
  Salesforce sees: no session cookie, not logged in

Step 2 — Salesforce → Your Browser (HTTP 302 Redirect)
  Location: https://acme.okta.com/sso/saml
  ?SAMLRequest=PHNhbWxwOi...   ← base64 encoded XML
  &RelayState=https://acme.salesforce.com/home

  Decoded SAMLRequest XML:
  <samlp:AuthnRequest
    ID="_abc123"
    Version="2.0"
    IssueInstant="2026-05-25T09:00:00Z"
    AssertionConsumerServiceURL="https://acme.salesforce.com/sso/saml"
    Issuer="https://acme.salesforce.com"
  />

Step 3 — Your Browser → Okta
  GET https://acme.okta.com/sso/saml?SAMLRequest=...
  Okta shows login page (if not already logged in)
  You enter: john@acme.com / secret123

Step 4 — Okta verifies against Active Directory (LDAP query internally)
  "Yes, john exists, password matches"

Step 5 — Okta → Your Browser (HTTP 302 back to Salesforce)
  POST https://acme.salesforce.com/sso/saml
  body:
  SAMLResponse=PHNhbWxwOi...   ← base64 encoded signed XML

  Decoded SAMLResponse XML:
  <samlp:Response>
    <Assertion>
      <Issuer>https://acme.okta.com</Issuer>
      <Subject>
        <NameID>john@acme.com</NameID>
      </Subject>
      <Conditions
        NotBefore="2026-05-25T09:00:00Z"
        NotOnOrAfter="2026-05-25T09:05:00Z"
      />
      <AttributeStatement>
        <Attribute Name="email">john@acme.com</Attribute>
        <Attribute Name="role">sales_manager</Attribute>
        <Attribute Name="department">sales</Attribute>
      </AttributeStatement>
      <Signature>
        <!-- Cryptographic signature by Okta's private key -->
        <!-- Salesforce verifies this with Okta's public cert -->
        MIIBkTCB+wIJAJ...
      </Signature>
    </Assertion>
  </samlp:Response>

Step 6 — Salesforce validates the signature using Okta's public certificate
  "Signature is valid, issued by Okta I trust, not expired"
  Creates a local session for john@acme.com

Step 7 — Salesforce → Browser
  Set-Cookie: SFDC_session=xyz789
  Redirect to /home → You're in!

```

Now you open Workday (another app):

Same flow, but Okta skips the login page (you already have an Okta session cookie)
Okta directly issues a SAML assertion for Workday
That's SSO — one login, many apps.

### 4. OAuth 2.0 — "Login with Google" / app permissions

Scenario: You sign up for Notion, and click "Continue with Google".

Actors:

You (browser)
Notion (the app, called the "Client")
Google (Authorization Server + Resource Server)

```
Step 1 — You click "Continue with Google" on Notion

Step 2 — Notion → Your Browser (redirect to Google)
  GET https://accounts.google.com/o/oauth2/auth
    ?client_id=notion-app-id-12345
    &redirect_uri=https://notion.so/callback
    &response_type=code
    &scope=openid email profile
    &state=random-csrf-token-xyz

  Breaking down:
  - client_id: Notion registered with Google, got this ID
  - scope: "I want to see email and profile only" (NOT your Drive/Gmail)
  - state: random value to prevent CSRF attacks

Step 3 — Google shows consent screen:
  "Notion wants to access:
   ✓ Your name
   ✓ Email address
   [ ] (NOT your Drive, Gmail, etc.)
   [Allow] [Deny]"

Step 4 — You click Allow
  Google → Your Browser (redirect back to Notion)
  GET https://notion.so/callback
    ?code=4/P7q7W4...    ← Authorization Code (expires in ~10 min)
    &state=random-csrf-token-xyz

  This code is NOT an access token yet. It's a one-time ticket.

Step 5 — Notion backend → Google (server to server, not browser!)
  POST https://oauth2.googleapis.com/token
  {
    code: "4/P7q7W4...",
    client_id: "notion-app-id-12345",
    client_secret: "super-secret-only-notion-knows",  ← never exposed to browser
    redirect_uri: "https://notion.so/callback",
    grant_type: "authorization_code"
  }

Step 6 — Google → Notion backend
  {
    access_token: "ya29.a0AfB_...",    ← use this to call Google APIs
    expires_in: 3600,                  ← valid 1 hour
    refresh_token: "1//0GW...",        ← use to get new access_token silently
    token_type: "Bearer",
    id_token: "eyJhbGci..."            ← JWT with your identity (this is OpenID Connect)
  }

  Decoded id_token (JWT):
  Header: { alg: "RS256", kid: "key-id" }
  Payload: {
    sub: "10769150350006150715113082367",  ← Google's unique user ID
    email: "john@gmail.com",
    name: "John Doe",
    picture: "https://...",
    iss: "https://accounts.google.com",
    aud: "notion-app-id-12345",
    exp: 1716631200,
    iat: 1716627600
  }
  Signature: [Google's RS256 signature]

Step 7 — Notion uses access_token to fetch profile (optional):
  GET https://www.googleapis.com/oauth2/v2/userinfo
  Authorization: Bearer ya29.a0AfB_...

  Response:
  {
    id: "10769150350006150715113082367",
    email: "john@gmail.com",
    name: "John Doe"
  }

Step 8 — Notion creates your account / logs you in
  Set-Cookie: notion_session=...
  → You're in Notion!

```

The critical difference: SAML tokens travel through your browser (in form POSTs). OAuth access tokens travel server-to-server — your browser never sees them. That's why OAuth is safer for API access.
