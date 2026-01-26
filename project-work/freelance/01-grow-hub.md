
Here’s a **step‑by‑step guide** to host your local static website on **Netlify** and connect it with your **GoDaddy domain** without using GitHub.  
This process works perfectly for static HTML/CSS/JS sites.
### Deployment steps

  
```sh

zip -r growthhub-portfolio.zip . -x "_.git_" "_.DS_Store_"
cd  /growthhub/growthHub-protfolio
```

---

## **Step 1: Prepare Your Website**

1. Make sure all files are in a **single root folder** (e.g. `growhub-site/`).
    
    - It should contain an `index.html` at its root.
        
    - Test locally by opening it in a browser (`file:///` path).
        

---

## **Step 2: Deploy to Netlify (Without GitHub)**

1. Go to **[https://www.netlify.com](https://www.netlify.com/)** and **sign up/login**.
    
2. Once logged in, click **“Add new site” → “Deploy manually”**.
    
3. **Drag and drop** your entire site folder (`growhub-site/`) into the upload box.
    
4. Wait a few seconds — Netlify will automatically publish it to a temporary URL such as:
    
    text
    
    `https://your-sitename.netlify.app`
    
5. Test your site using that URL to confirm it loads correctly.
    

---

## **Step 3: Add Your Custom Domain from GoDaddy**

1. In Netlify, go to your site → **Site Settings → Domain Management → Add Custom Domain**.
    
2. Enter your purchased domain (e.g. **growhub.in**) and click **Verify**.
    
3. Netlify will show two options:
    
    - **Option A: Use Netlify DNS** – Recommended if you don’t have email setup on GoDaddy.
        
    - **Option B: Keep GoDaddy DNS** – Recommended if you use GoDaddy for email (e.g. workspace email).
        

Let’s go with **Option B** (simpler and safer if you already have GoDaddy DNS running).

---

## **Step 4: Update DNS Records in GoDaddy**

1. Log in to **GoDaddy** → open **My Products** → beside your domain click **DNS → Manage DNS**.
    
2. Under **DNS Records**, do the following:
    
    - Delete any existing “A” record pointing to old IPs.
        
    - Add the following records Netlify provides under the “External DNS” section:
        
    
    **Type:** `A`  
    **Name:** `@`  
    **Value:**
    
    text
    
    `75.2.60.5 99.83.190.102`
    
    (Both IPs are official Netlify load balancers )[netlify+1](https://docs.netlify.com/manage/domains/get-started-with-domains/)​
    
    **Type:** `CNAME`  
    **Name:** `www`  
    **Value:** `your-site-name.netlify.app` (your temporary Netlify subdomain)
    
3. Save changes.
    
4. In Netlify → under **Domain Settings** click **Verify DNS Configuration**.
    
    - It might take 30–60 minutes for DNS to propagate.
        

---

## **Step 5: Enable HTTPS**

1. Once DNS is verified, go to **Domain Management → HTTPS** in Netlify.
    
2. Click **“Verify DNS configuration”** → **Enable HTTPS** → Netlify will auto‑issue a **Let’s Encrypt SSL**.
    

---

## **Step 6: Test Everything**

1. Visit your domain (e.g. [https://growhub.in](https://growhub.in/)).
    
2. Confirm:
    
    - It loads your Netlify‑hosted site.
        
    - HTTPS padlock is active.
        

---

## **Optional: Future Updates**

To update your site:

1. Locally modify your HTML/CSS/JS.
    
2. Return to **Netlify → Your Site → Deploys**.
    
3. Click **Upload and replace existing deploy**, then drag‑and‑drop your updated folder again.
    

---

## **Summary**

- **Netlify** gives free SSL, CDN, and analytics.
    
- **GoDaddy** continues managing your domain and emails.
    
- **No GitHub** needed — just drag & drop your code and map the domain.
    

---

Would you like a **one‑page visual checklist (deploy + DNS setup)** that you can print or keep handy when doing this live?

1. [https://docs.netlify.com/manage/domains/get-started-with-domains/](https://docs.netlify.com/manage/domains/get-started-with-domains/)
2. [https://neophyte.home.blog/2021/07/06/connect-a-godaddy-domain-to-a-netlify-website/](https://neophyte.home.blog/2021/07/06/connect-a-godaddy-domain-to-a-netlify-website/)
3. [https://www.youtube.com/watch?v=bY7Tkh9Vz8I](https://www.youtube.com/watch?v=bY7Tkh9Vz8I)
4. [https://answers.netlify.com/t/how-to-use-godaddy-domain-with-netlify-hosted-site-while-domain-is-being-used-for-email-with-godaddy/124369](https://answers.netlify.com/t/how-to-use-godaddy-domain-with-netlify-hosted-site-while-domain-is-being-used-for-email-with-godaddy/124369)
5. [https://michaelneuper.com/posts/how-to-create-your-own-website/](https://michaelneuper.com/posts/how-to-create-your-own-website/)
6. [https://www.youtube.com/watch?v=QeMByHSaejM](https://www.youtube.com/watch?v=QeMByHSaejM)
7. [https://www.reddit.com/r/Frontend/comments/1jsymui/how_can_i_host_a_very_cheap_website_please/](https://www.reddit.com/r/Frontend/comments/1jsymui/how_can_i_host_a_very_cheap_website_please/)
8. [https://www.eevblog.com/forum/chat/free-web-hosting-that-supports-custom-domain-names/](https://www.eevblog.com/forum/chat/free-web-hosting-that-supports-custom-domain-names/)
9. [https://github.com/orgs/community/discussions/138850](https://github.com/orgs/community/discussions/138850)
10. [https://answers.netlify.com/t/setting-up-site-using-netlify-godaddy/16416](https://answers.netlify.com/t/setting-up-site-using-netlify-godaddy/16416)