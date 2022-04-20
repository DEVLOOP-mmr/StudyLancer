import 'package:elite_counsel/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Variables.backgroundColor,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Variables.backgroundColor,
          leading: Navigator.of(context).canPop()
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : null,
          centerTitle: false,
          title: Text(
            'Terms & Conditions',
            style: TextStyle(
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: <Color>[Color(0xffFF8B86), Color(0xffAE78BE)],
                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                //color: Colors.blue[900],
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontFamily: 'Roboto',
                fontSize: 20),
          ),
        ),
        body: SafeArea(
          child: Container(
              color: Variables.backgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Html(
                      data: """
                      <p dir="ltr"><span>For Students</span></p>
<p dir="ltr"><span>This privacy notice has been compiled to help you understand why we ask you for your personal information when you use one of our websites and how we will store and use this information.</span></p>
<p dir="ltr"><span>Study Lancer Connect Limited, an Study Lancer Education owned company. At the heart of our work is helping you and other users find suitable courses and learning providers. This is defined as our Legitimate Business Interest. We process your personal data to help you make informative decisions when selecting courses and learning providers. We do that by:</span></p>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Providing extensive educational information</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Providing advertising and promotional opportunities for education providers</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Providing features to enable users to directly contact education providers</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Recommending things which we think you&rsquo;ll like, such as courses and learning providers</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Notifying you about things you&rsquo;ve told us you like, such as a new course in your local area</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Personalizing sections of our websites to your preferences</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Dealing with any requests you make or content you submit</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Getting in touch if we need to tell you about something, like a change to our policies or issues with our service</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Monitoring usage and performance in order to improve the services we offer.</span></p>
</li>
</ul>
<p dir="ltr"><span>This privacy notice applies to all our website and app users regardless of location, whether registered or not, including people responding to surveys, competitions and writing reviews. We refer to all registered users as &ldquo;members of our community&rdquo;</span></p>
<p dir="ltr"><span>Keeping your information safe and private is very important to us. All our services are designed with privacy and security in mind. We will never sell your personal information to any third party.</span></p>
<h3 dir="ltr"><span>Collecting and using your personal data</span></h3>
<p dir="ltr"><span>You can browse our websites without providing any personal information. However, to use some of our enhanced functionality will sometimes ask for additional information in order to process your request. Examples include:</span></p>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Providing your name, email, and contact details to request a prospectus or make an enquiry to an education provider.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Providing your name, email address, and preferences to create an account to receive email newsletters and save your preferences.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Providing your name, contact details, and education history to engage with offline education counseling services.</span></p>
</li>
</ul>
<p dir="ltr"><span>The details we request for each piece of enhanced functionality will depend on what is required to perform the action. For example:</span></p>
<ul>
<li dir="ltr">
<p dir="ltr"><span>If we need to contact you by email, we will request your email address.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>If we tailor your experience by displaying available courses, we will ask for your preferred start date.</span></p>
</li>
</ul>
<p dir="ltr"><span>Details of why we collect each piece of information is displayed clearly next to the field used to enter the data.</span></p>
<p dir="ltr"><span>A full list of the data collected by each website is available on the site-specific data collection notice.</span></p>
<p dir="ltr"><span>We also collect some technical information while you use our websites. For example, information on the type of browser you use and your IP address. This information is used to maintain and monitor the performance of our websites.</span></p>
<h4 dir="ltr"><span>Cookies</span></h4>
<p dir="ltr"><span>We use cookies on our websites to provide login and preferences functions, and to collect anonymised data on user interactions. For example, we use cookies to:</span></p>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Keep you logged into the website.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Understand and save your user preferences for future personalised experience and to allow us to deliver the type of content and products in which you are most interested.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Compile anonymised data about site traffic and site interactions in order to offer better site experiences and tools in the future. We use tools such as Google Analytics, Study Lancer Connect Insights, and the Study Lancer Connect Enrolment Matcher Tool to do this.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>To provide targeted content and advertising based on your preferences and previous interactions. We work with third-party companies to provide targeted advertising. Personal data is not shared with these companies. Further details of the companies we work with are available within our Cookie Policy.</span></p>
</li>
</ul>
<p dir="ltr"><span>Personal information is never held on any of our first-party cookies.</span></p>
<p dir="ltr"><span>You can choose to have your computer block some or all cookies for you. You do this through your browser settings. Each browser is a little different, so look at your browser's Help menu to learn the correct way to modify your cookies.</span></p>
<p dir="ltr"><span>If you disable cookies, some advanced features will be disabled and some of our services may not function as intended.</span></p>
<p dir="ltr"><span>You can read more about how we use cookies on our&nbsp;</span><a href="https://www.hotcoursesabroad.com/india/study/cookie-details.html"><span>Cookie Policy</span></a><span>.</span></p>
<h4 dir="ltr"><span>Anonymised analytics and insights</span></h4>
<p dir="ltr"><span>Occasionally, we will ask for additional information to help us monitor the reach and effectiveness of our services. For example, when creating an account, we may ask for your country of residence or postcode. This data will only ever be used in an anonymised format to help us demonstrate the effectiveness and improve the products and services we offer.</span></p>
<p dir="ltr"><span>We use Google Analytics to log review aggregated use data across all of our websites. No personal data is shared with Google Analytics.</span></p>
<h4 dir="ltr"><span>Geographical data and geotargeting</span></h4>
<p dir="ltr"><span>As with all websites, your IP address is sent to us each time a webpage is viewed. For some functionality we use this, along with geo-location information provided by your browser to provide location specific content within our websites and apps. When you browse our website or use our apps your IP address and location information is stored on our system anonymously unless you are a registered user in which case it will be possible to link it to your profile. This link will only exist temporarily and will be removed three months after your visit. We will not use this information to identify you personally. We use location data for analytics purposes, in order to understand the locations our products are successful in and to ultimately, deliver a better service. You can stop sharing this information by changing your browser settings.</span></p>
<h4 dir="ltr"><span>Mobile app specific settings</span></h4>
<p dir="ltr"><span>We offer push notifications, location based services, and targeting advertising through our apps. When you first use one of our apps, you will be asked whether or not you want to turn-on these services. You can opt-out of these services at any time using the changing the permissions through your device settings.</span></p>
<h3 dir="ltr"><span>Storing your data</span></h3>
<p dir="ltr"><span>The personal data you provide is stored in a secure hosting environment based in the UK. We employ a range of technology and procedures to ensure that this data is secure, including encryption, anti-virus and anti-malware software, intrusion detection, company-wide data usage policies, and mandatory security and privacy staff training..</span></p>
<h3 dir="ltr"><span>How long will you keep my information for?</span></h3>
<p dir="ltr"><span>We will keep your data for as long as we are required to, either:</span></p>
<ul>
<li dir="ltr">
<p dir="ltr"><span>By law, for example to meet financial regulations relating to payments</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>For as long as we require the data to provide a service to you</span></p>
</li>
</ul>
<p dir="ltr"><span>Personal data is deleted in accordance with our internal retention policy. All identifiable personal data is deleted three years following your last interaction with this website, for users registering from within the UK and after two years for international markets.</span></p>
<h3 dir="ltr"><span>Your rights</span></h3>
<h4 dir="ltr"><span>Reviewing and updating your data</span></h4>
<p dir="ltr"><span>You can update the information we store on your behalf by logging into your website account and updating your profile. If you were not assigned a password when creating your account, you can request a new password online by selecting the &lsquo;forgotten password&rsquo; option. If you do not have access to this account, you can request a data update by contacting the Privacy Manager</span></p>
<p dir="ltr"><span>In line with the privacy regulations across the world, including GDPR (European Union) and CCPA (California, USA), you have the following rights:</span></p>
<h4 dir="ltr"><span>The right to be informed</span></h4>
<p dir="ltr"><span>You have the right to be informed why and how we collect your personal data, how we will use this information, who we share it with, what are the security measures we take to protect this information and what are your individual rights. We will publish this information in this Privacy Notice.</span></p>
<h4 dir="ltr"><span>The right of access</span></h4>
<p dir="ltr"><span>You have the right to access the information we hold for you by requesting us or logging into your online profile, if you require a permanent record you can download this information in PDF format from our website. Alternatively you can make an offline Subject Access Request by contacting the Privacy Manager.</span></p>
<h4 dir="ltr"><span>The right to rectification</span></h4>
<p dir="ltr"><span>You have the right for inaccurate or incomplete data we hold to be updated. You can make a request to have your data updated through the Privacy Manager.</span></p>
<h4 dir="ltr"><span>The right to erasure</span></h4>
<p dir="ltr"><span>You have the right to be forgotten at any point by contacting the Privacy Manager. At your request, we will remove all the data we have for you which we are not required legally to retain.</span></p>
<h4 dir="ltr"><span>The right to restrict processing</span></h4>
<p dir="ltr"><span>You have the right to restrict processing when you have exercised one of the above rights and it may take some time to process that request. For example: when you contact us to update your details you have the right to request restriction until your details are updated.</span></p>
<h4 dir="ltr"><span>Right to withdraw consent</span></h4>
<p dir="ltr"><span>For the processing activities where we have asked you for consent, you have the right to withdraw this consent at any point by clicking on the unsubscribe link in any email we send you, or by updating your profile in the application or by contacting the Privacy Manager.</span></p>
<h4 dir="ltr"><span>The right to object</span></h4>
<p dir="ltr"><span>You can object to the processing of your personal data at any point by contacting the Privacy Manager. There may be instances where we may not be able to fulfil those requests, but we will provide you with explanation when replying back to you.</span></p>
<h4 dir="ltr"><span>Right to not be subject to automated decisions and profiling</span></h4>
<p dir="ltr"><span>None of our processing activities are purely automated. There are instances where we process data to analyse or predict behaviour but we will ask you for explicit consent when this processing will involve your personal data.</span></p>
<h4 dir="ltr"><span>Right to data portability</span></h4>
<p dir="ltr"><span>If you have provided us with your personal data with consent or under the contact obligations, you have the right to request the data you have provided to us in a machine-readable format should you decide to move to another data controller.</span></p>
<h3 dir="ltr"><span>Marketing and Email Newsletters</span></h3>
<p dir="ltr"><span>As industry experts, it is our primary objective to help you with your educational journey. As part of this, we offer a number of subscription options for you to choose from.</span></p>
<p dir="ltr"><span>You have the following two marketing options sent directly from us:</span></p>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Newsletters</span><span>&nbsp;- inspiring emails from our editorial team, providing you with the latest university news, tips and guides.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>University Updates</span><span>&nbsp;- emails sent from us providing news and updates of course information, open days, events and scholarships from universities and partners that match your interests. You will receive these newsletters based on your course, institution or location search history. We will not share your personal data with these institutions. We will only partner with carefully selected education sector institutions that have compatible activities and can help you with your journey. You can withdraw your consent at any point by logging in to our website and going to your profile page.</span></p>
</li>
</ul>
<h4 dir="ltr"><span>Marketing options from our partner institutions</span></h4>
<p dir="ltr"><span>When you use our applications you may also be invited to subscribe to our partners&rsquo; (Universities) marketing directly. When this option is available there will be a consent box on the relevant form with a link to the partner&rsquo;s Privacy Notice. Before subscribing please read the Privacy Notice of the partner as they are acting as a separate data controller and may have different processing activities and retention schedules to our own.</span></p>
<p dir="ltr"><span>If you give consent to a University, you will need to contact the University directly to subsequently withdraw your consent or change your preferences. You can find out which universities you have subscribed to by accessing your profile page when you are logged in to your account.</span><span><br /></span><span>For more details please contact us via the contact details provided in this Notice.</span></p>
<h3 dir="ltr"><span>Market Research, Surveys and Competitions</span></h3>
<p dir="ltr"><span>To be in a position to offer you beneficial services and products, or to advise our partners on your educational preferences, we often run surveys and market research campaigns which you can choose to take part in.</span></p>
<p dir="ltr"><span>The data collection, use and storage vary depending on the focus of the research. Before supplying any personal information and for more details on the research we are conducting, please read the privacy note included on each survey or survey invitation you receive from us. We currently run surveys using a 3rd party platform called Typeform.</span></p>
<p dir="ltr"><span>For market research, we may engage a specialist company to conduct the research on our behalf and they may have access to your personal data. We will take all steps necessary to protect your personal data throughout the research period and either randomise it or delete it when it is no longer required.</span></p>
<p dir="ltr"><span>To reward people for taking part in our surveys, market research or social media engagement campaigns we often run competitions. If you would like to take part in such a competition, we will ask you to enter an email address. We will only use this information to contact you if you are the competition winner and to arrange a prize delivery. We will delete all personal information collected as part of a competition 1 month following the competition closing date.</span></p>
<h3 dir="ltr"><span>Multimedia Content</span></h3>
<p dir="ltr"><span>As part of multimedia production activities, Study Lancer Connect processes personal data on the basis of consent. There are number of instances when we may ask you to take part in a video or appear in a photograph:</span></p>
<p dir="ltr"><span>Student Events (organised or attended by our team)</span><span>&nbsp;Video and photo materials recorded at the event are used to stream the event live and/or promote future events. Some of these events will be featured in an article published on our websites and use video and photographic material from the event.</span></p>
<p dir="ltr"><span>Promotional Video Production Events (commissioned by our clients)</span><span>&nbsp;These videos and photographs are used to promote a specific university and highlight certain aspects of the facilities the university has to offer.</span></p>
<p dir="ltr"><span>Review videos (recorded by our review collection team or supplied by you directly)&nbsp;</span><span>These videos are produced to give our users an independent view of your student experience. Each time we record a video, or take a photograph, we will ask for your consent and provide you with a form containing specific information about the filming/photoshoot event. Please read all the information before signing.</span></p>
<h3 dir="ltr"><span>Social Media</span></h3>
<p dir="ltr"><span>We use social media to make our editorial content more accessible and interact with you. You can engage with us by reading, sharing and commenting on our posts. You can also share any article that has that option on your social media page. When creating a post or leaving comments on a post, please do not leave any personal details as these posts are made public and anyone can see them. Instead, if you need to ask a more specific question, please send us a private message. Private messages will be stored for 1 year and will not be shared with anyone outside our company.</span></p>
<p dir="ltr"><span>When you log in to our websites using Facebook credentials, we will create a user account for you using your details from Facebook. This is necessary as some of the features like making an enquiry or downloading prospectuses are only available to registered users.</span></p>
<p dir="ltr"><span>You can stop sharing this information with us directly from your Facebook account. Please note this will not delete the data we have already received (name, email address or profile picture).</span></p>
<p dir="ltr"><span>When contacting us via social media platforms please familiarise yourself with the privacy notice of that platform</span></p>
<h3 dir="ltr"><span>Sharing your data with partners</span></h3>
<p dir="ltr"><span>We work with a range of learning providers that either advertise courses on our platforms or offer services relevant to your educational research journey.</span></p>
<p dir="ltr"><span>Your personal data will only be shared with learning providers you have chosen to engage with via our websites. For example, when you make an enquiry or a prospectus request to an institution, your details relating to that enquiry will be provided to the institution so that they may answer your enquiry directly.</span></p>
<p dir="ltr"><span>We also provide anonymised site usage data to providers to enable them to monitor enrolment from users who use our websites.</span></p>
<p dir="ltr"><span>If you take part in one of our market research campaigns or surveys, we will never share your personal data with our partners, we only share aggregated data that cannot identify you individually. Our data handling procedures ensure your personal data is protected through the service you receive from us. Furthermore, we have data sharing agreements in place with our partners to make sure they apply security operational and technical measures when processing your personal information.</span></p>
<h3 dir="ltr"><span>Links to other websites</span></h3>
<p dir="ltr"><span>On our website there are lots of links to course provider websites. This privacy notice does not cover these links. We encourage you to read the privacy statements on the other websites you visit.</span></p>
<h3 dir="ltr"><span>Changes to the Privacy Notice</span></h3>
<p dir="ltr"><span>The date of the most recent version will appear on the top of this page. From time to time we may be updating this Privacy Notice, please review it each time you are to submit personal information. If we make any significant changes to this notice we will send you an email informing you of these amendments. If you do not agree with these changes please do not use our websites to provide personal information. You can also delete your account at any time &ndash; please see your rights section.</span></p>
<h3 dir="ltr"><span>Further questions</span></h3>
<p dir="ltr"><span>If you have any questions or complaints regarding your personal data, please contact the Privacy Manager at the address below:</span></p>
<p dir="ltr"><span>Privacy Manager</span><span><br /></span><span>Study Lancer Connect Ltd</span><span><br /></span><a><span>ABC</span><span><br /></span><span><br /><br /></span></a></p>
<p dir="ltr"><span>If you feel the Privacy Manager has not dealt with your enquiry promptly or correctly, you have the right to complain to the ICO&nbsp;</span><a href="https://ico.org.uk/make-a-complaint/"><span>https://ico.org.uk/make-a-complaint/.</span></a></p>
<h1 dir="ltr"><span>Site specific privacy notice</span></h1>
<p dir="ltr"><span>The following section provides information on the collection and processing of personal data specific to the elitecounsel website and mobile application.</span></p>
<p dir="ltr"><span>This site is available at&nbsp;</span><span>ABCD</span></p>
<p dir="ltr"><span>The site is intended for use by users aged 16 years and over. Users under this age are not allowed to create an account on the website.</span></p>
<p dir="ltr"><span>You will need to register with Elitecounsel to get a full range of services such as sending enquiries, ordering prospectuses, downloading e-books, adding favorites universities, saving search results or leaving reviews. To get the most appropriate search results, advice and guidance, we strongly recommend you register with us and provide the information requested within your profile.</span></p>
<h3 dir="ltr"><span>What personal data do we collect?</span></h3>
<p dir="ltr"><span>You can access all personal data we have collected about you from your Study Lancer online profile page.</span></p>
<h4 dir="ltr"><span>Data collected directly</span></h4>
<p dir="ltr"><span>The following items of personal data are collected as part of the registration process:</span></p>
<ul>
<li dir="ltr">
<p dir="ltr"><span>First name</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Last name</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Email</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Country of residence</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Nationality</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Intake year and month</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Preferred study destination</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Subject</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Study level</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Date of birth</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Phone number</span></p>
</li>
</ul>
<p dir="ltr"><span>Under your user profile, you can choose to add additional information:</span></p>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Gender</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Mailing address</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Current qualification</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Current qualification status</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Grade type of current qualification</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Score of current qualification</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Date of completion of current qualification</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Test completed</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>English proficiency test scores</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Other tests</span></p>
</li>
</ul>
<h4 dir="ltr"><span>Data collected indirectly</span></h4>
<p dir="ltr"><span>Study Lancer allows you to log in to the website using your Facebook account. The following items of personal data are collected if you use Facebook to register or login on Study Lancer India website:</span></p>
<ul>
<li dir="ltr">
<p dir="ltr"><span>First name</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Last name</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Gender</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Email address</span></p>
</li>
</ul>
<p dir="ltr"><span>We collect your search history and the articles you have read. We use this information to suggest courses you may be interested in or are eligible to apply to.</span></p>
<h4 dir="ltr"><span>IP Address</span></h4>
<p dir="ltr"><span>Each time you access our website we will receive your IP Address. We keep this information for 3 months only and use it for analytics purposes only.</span></p>
<h3 dir="ltr"><span>How we process your data</span></h3>
<p dir="ltr"><span>While using the Study Lancer India website, you can carry out the following interactions where we process your personal data:</span></p>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Creating a user account</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Making an enquiry to a university</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Requesting a prospectus from a university</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Downloading e-books</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Initiating counselling services with our parent company Study Lancer Education</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Booking a place at an open day</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Adding an institution review</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Search filtering</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Contact us</span></p>
</li>
</ul>
<p dir="ltr"><span>We use your personal details to respond to your enquiry i.e. create an account for you; answer your question, contact you if you are one of a prize draw winner (when taking part in a competition) or send you newsletters if you have subscribed.</span><span><br /></span><span>We also use your personal data and search history to suggest tailored content such as posts, universities and courses.</span></p>
<h4 dir="ltr"><span>Consent options</span></h4>
<p dir="ltr"><span>As part of the registration process, you have the choice to opt-in to the following:</span></p>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Newsletters from Study Lancer India</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>University updates sent by us on behalf of third-party partners</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Market research, surveys and competitions</span></p>
</li>
</ul>
<h4 dir="ltr"><span>In addition, you can also opt in to:</span></h4>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Marketing communication from our partner institutions (external subscription where you can opt in to receive newsletters and marketing materials from your chosen Universities directly)</span></p>
</li>
</ul>
<p dir="ltr"><span>When the option is available you can also consent to be contacted further from Study Lancer India for editorial purposes.</span></p>
<p dir="ltr"><span>All consent except the marketing options from our partner institutions can be withdrawn at any point by contacting the Study Lancer India Privacy Manager, by updating your mailing preferences available within your profile online or clicking on the unsubscribe link available in every email you receive from us.</span></p>
<p dir="ltr"><span>To withdraw your consent for marketing from one of our partner institutions (when given on Study Lancer India) you will need to contact the institution directly. You can view which institutions you have consented to via your Study Lancer India profile page.</span></p>
<p dir="ltr"><span>When using Facebook to login to Study Lancer India, you have the option to share your activity on Study Lancer India with your Facebook friends.</span></p>
<h3 dir="ltr"><span>Data sharing</span></h3>
<p dir="ltr"><span>Your contact details are shared with the education institutions where you have made an enquiry with or request a prospectus from so that they can accommodate your request directly.</span></p>
<p dir="ltr"><span>Any review you have supplied will be posted on Study Lancer India and associated social media channels (Facebook, Twitter, Instagram).</span></p>
<h2 dir="ltr"><span><span>&nbsp;</span></span></h2>
<p dir="ltr"><span>For Agents</span></p>
<h1 dir="ltr"><span>Terms and Conditions</span></h1>
<p dir="ltr"><span>These terms and conditions (the &ldquo;</span><span>Terms and Conditions</span><span>&rdquo;), including the Privacy Policy and other documents referred to in these terms and conditions (the &ldquo;</span><span>Agreement</span><span>&rdquo;) is a legal agreement between you (hereinafter, &ldquo;</span><span>you</span><span>&rdquo; or &ldquo;</span><span>your</span><span>&rdquo;) and Study Lancer Inc., hereinafter referred to Study Lancer (&ldquo;</span><span>Study Lancer</span><span>&rdquo;), respecting your use of the Services as described herein.</span></p>
<p dir="ltr"><span>BY INDICATING YOUR ACCEPTANCE BY CLICKING ON THE APPROPRIATE BUTTON WHEN SIGNING UP FOR THE SERVICES, OR BY OTHERWISE USING THE SERVICES, YOU ARE AGREEING TO BE BOUND BY THE TERMS OF THIS AGREEMENT. IF YOU DO NOT ACCEPT AND AGREE TO BE BOUND BY THE AGREEMENT DO NOT ACCESS OR USE THE Study Lancer SOLUTION.</span></p>
<p dir="ltr"><span>If you have any questions or concerns about the terms of this Agreement, please contact us at&nbsp;</span><a><span>info@Study Lancer.com</span></a><span>.</span></p>
<h2 dir="ltr"><span>1. Definitions</span></h2>
<p dir="ltr"><span>In these Terms and Conditions:</span></p>
<ul>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>Access Information</span><span>&rdquo; has the meaning set out in Section 6.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>Agreement</span><span>&rdquo; has the meaning set out in the first paragraph of these Terms and Conditions.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>Applicable Law</span><span>&rdquo; means any domestic or foreign law, rule, statute, subordinate legislation, regulation, by-law, order, ordinance, protocol, code, guideline, treaty, policy, notice, direction or judicial, arbitral, administrative, ministerial or departmental judgment, award, decree, treaty, directive, or other requirement or guideline published or in force at any time during the term of this Agreement which applies to or is otherwise intended to govern or regulate any person (including any Party), property, transaction, activity, event or other matter, including any rule, order, judgment, directive or other requirement or guideline issued by any Governmental or Regulatory Authority</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>Application</span><span>&rdquo; has the meaning set out in Section 2(a)(ii).</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>Study Lancer Partner</span><span>&rdquo; means any educational institution, company, organization, association or individual that has entered into an agreement with Study Lancer to use or promote the Study Lancer Solution, or to enable their employees or students to use or promote the Study Lancer Solution.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>Study Lancer Solution</span><span>&rdquo; means the Study Lancer website and the Services, including the Content therein, as modified from time to time.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>Confidential Information</span><span>&rdquo; means information considered confidential or proprietary by Study Lancer, including the Study Lancer Solution, its business plan and strategy, any design, prototype, compilation of information, data, program, method, invention, license, technique or process, information relating to any Study Lancer service, Study Lancer&rsquo;s software, website and web platform, client and user information, financial information, marketing information, intellectual property, business opportunities, or research and development.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>Content</span><span>&rdquo; has the meaning set out in Section 2(a)(i).</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>De-identified Data</span><span>&rdquo; has the meaning set out in Section 5.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>Governmental or Regulatory Authority</span><span>&rdquo; means any national, provincial, territorial, state, county, municipal, quasi-governmental or self-regulatory department, authority, organization, agency, commission, board, tribunal, dispute settlement panel or body, bureau, official, minister, Crown corporation, or court or other law, rule or regulation-making entity having or purporting to have jurisdiction over Study Lancer, you or any other person, property, transaction, activity, event or other matter related to this Agreement, including subdivisions of, political subdivisions of and other entities created by, such entities</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>Party</span><span>&rdquo; means each of Study Lancer and you, and &ldquo;</span><span>Parties</span><span>&rdquo; means Study Lancer and you collectively.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>Personal Information</span><span>&rdquo; means information about an identifiable individual.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>Privacy Policy</span><span>&rdquo; has the meaning set out in Section 4(e).</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>Program</span><span>&rdquo; means a study program, language programs, summer camps, including one of the academic programs or a program specifically designed to transition international students (sometimes referred to as a pathway program), offered by the Study Lancer Partners.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>Recruiter</span><span>&rdquo; means any individual or entity that you engage to represent you to submit an Application using the Study Lancer Solution.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>Services</span><span>&rdquo; has the meaning set out in Section 2.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>Submission</span><span>&rdquo; has the meaning set out in Section 11(a).</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>Terms and Conditions</span><span>&rdquo; has the meaning set out in the first paragraph of these terms.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&ldquo;</span><span>Your Data</span><span>&rdquo; has the meaning set out in Section 4(a)(i).</span></p>
</li>
</ul>
<h2 dir="ltr"><span>2. Services</span></h2>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer&rsquo;s services described in this Section 2 (collectively referred to as the &ldquo;</span><span>Services</span><span>&rdquo;) consist of the following:</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer will provide access to certain information, material or content (including, pricing, features, promotion and information of third parties) contained on or provided through the Study Lancer website (the &ldquo;</span><span>Content</span><span>&rdquo;) to provide information to assist you through the process of becoming a student at certain Study Lancer Partners within Canada and the U.S., including Program information;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer will provide you with the ability to input Your Data into the Study Lancer Solution and will act as an intermediary to pass Your Data to the applicable Study Lancer Partners in order to enable you to apply to Programs offered by such Study Lancer Partners (each, an &ldquo;</span><span>Application</span><span>&rdquo;); and</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer will facilitate an Application by, on a case-by-case basis, assisting you with communications with the applicable Study Lancer Partners, passing through Application fees and other payments associated with an Application, and providing guidance and advice associated with an Application.</span></p>
</li>
</ul>
</ul>
<h2 dir="ltr"><span>3. License to Use the Study Lancer Solution</span></h2>
<p dir="ltr"><span>Subject to the terms and conditions in the Agreement and any restrictions contained in the Content, Study Lancer hereby grants you a personal, non-exclusive, revocable, non-transferable license to access the Study Lancer Solution solely for the purposes of using the Services, view the Content, and submit an Application to Study Lancer Partners.</span></p>
<h2 dir="ltr"><span>4. Your Data</span></h2>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Your Data Must be Complete and Accurate</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>In order to use the Study Lancer Solution, you must:</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>provide up-to-date complete and accurate Personal Information or other data submitted by you to the Study Lancer Solution or otherwise provided to Study Lancer, including name information, contact information, citizenship and legal status, gender, date of birth, home and mailing address, marital status, emergency contact information, financial information, education qualification, employment information, educational information, transcript, English or French test score, passport details, information required for visa application, including financial and medical information (&ldquo;</span><span>Your Data</span><span>&rdquo;), as requested by Study Lancer on Study Lancer&rsquo;s website, and as required to process your Application;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>where payment is required, provide up-to-date, complete and accurate payment information as required by Study Lancer or Study Lancer&rsquo;s third party payment processor, as applicable (which may include a valid PayPal or Stripe account, or credit card information for a credit card that is valid and legally registered to you); and</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>OBTAIN ALL RELEVANT PERMISSIONS FROM ANY AFFECTED THIRD PARTY, SUCH AS YOUR EDUCATIONAL INSTITUTION, FOR Study Lancer TO COLLECT YOUR DATA.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Ownership of Your Data</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Nothing herein transfers any ownership of Your Data to Study Lancer in its original form.</span></p>
</li>
</ul>
</ul>
</ul>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Quality of Your Data and Feedback</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Without limiting the foregoing, Study Lancer does not assess Your Data for quality or otherwise. Study Lancer, Study Lancer Partners and other third parties to whom Study Lancer is permitted to pass Your Data under this Agreement, may rely on the accuracy of Your Data provided by you to the Study Lancer Solution.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Any feedback that you receive respecting Your Data is not as the result of any specific examination of the data by Study Lancer, or any judgment exercised by Study Lancer respecting Your Data, but rather is solely based on the compliance requirements of Study Lancer Partners.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Consent to Processing of Your Data</span></p>
</li>
</ul>
<p dir="ltr"><span>An integral part of the Study Lancer Solution entails the collection; processing, transmission and disclosure of Your Data by Study Lancer, Study Lancer Partners and their service providers, and you hereby specifically consent to:</span></p>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer&rsquo;s provision of Your Data to any Study Lancer Partner, visa agencies, English and French test score organizations, professional bodies, service providers to Study Lancer (including our hosting providers) as part of the provision of the Study Lancer Solution to you, and Governmental or Regulatory Authorities; and</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Communications from Study Lancer (including e-mail communications, both marketing and informational) respecting the Study Lancer Solution, and Study Lancer&rsquo;s products and services.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Privacy Policy</span></p>
</li>
</ul>
<p dir="ltr"><span>Your Personal Information will be handled in accordance with Study Lancer&rsquo;s Privacy Policy accessible via the following link:&nbsp;</span><a href="https://www.applyboard.com/ca/privacy-policy"><span>https://www.Study Lancer.com/ca/privacy-policy</span></a><span>&nbsp;(the &ldquo;</span><span>Privacy Policy</span><span>&rdquo;). Notwithstanding the foregoing, Study Lancer reserves the right at all times to disclose any Personal Information as it deems necessary to satisfy any Applicable Law, legal process or requirements of a Governmental or Regulatory authority.</span></p>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Storage of Your Data in Other Jurisdictions</span></p>
</li>
</ul>
<p dir="ltr"><span>You acknowledge that, due to the nature of the Study Lancer Solution, Your Data uploaded to the Study Lancer Solution may be hosted on servers residing in jurisdictions other than Canada, over which Study Lancer has no direct control. By using the Study Lancer Solution, Your Data may become, during the period that Your Data is hosted on such servers, subject to the Applicable Laws of the jurisdiction in which such servers reside or to the terms of agreements respecting the hosting of data on such servers.</span></p>
<h2 dir="ltr"><span>5. De-Identified Data</span></h2>
<p dir="ltr"><span>Study Lancer may also use itself or provide to third parties, Your Data, and any data regarding your use of the Study Lancer Solution, in aggregated form, in a manner that does not identify you (&ldquo;</span><span>De-Identified Data</span><span>&rdquo;), subject to Study Lancer&rsquo;s Privacy Policy, for Study Lancer&rsquo;s business uses, including for the purposes of enhancing and fixing the Study Lancer Solution, performing analytics, marketing the Study Lancer Solution to third parties, and selling such De-Identified Data for profit. Study Lancer will own any and all intellectual property rights in the output of Study Lancer&rsquo;s use of any such De-identified Data.</span></p>
<h2 dir="ltr"><span>6. Your Access Information</span></h2>
<p dir="ltr"><span>Study Lancer will provide you with certain information to allow you to use the Study Lancer Solution, such as one or more user IDs and passwords and/or the ability to create user IDs and/or passwords (the &ldquo;</span><span>Access Information</span><span>&rdquo;). The Access Information is provided on the understanding that it is personal to you; you will not permit anyone other than you or your authorized representatives to obtain access to the Study Lancer Website using the Access Information.</span></p>
<h2 dir="ltr"><span>7. Your Representations and Warranties</span></h2>
<p dir="ltr"><span>You covenant, represent and warrant that:</span></p>
<ul>
<li dir="ltr">
<p dir="ltr"><span>you have reached the age of majority in your jurisdiction of residence and have the legal authority to create a binding legal obligation;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you will not permit anyone other than yourself or your authorized designate to obtain access to the Study Lancer Solution through your Study Lancer account or otherwise using your Access Information;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you will only use the Study Lancer Solution in accordance with this Agreement and Applicable Law;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you will comply with all applicable intellectual property laws in your use of the Study Lancer Solution and not infringe, violate or misappropriate the intellectual property rights of any third party;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you will comply with any Study Lancer Partner policies and procedures applicable to your Application;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Your Data is true, accurate, current and complete, and if it becomes inaccurate, that you will promptly notify Study Lancer or update Your Data on the Study Lancer Solution;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>to the extent that you engaged a Recruiter to provide Your Data on your behalf for the purposes of using the Study Lancer Solution: (A) that the Recruiter has a legitimate educational interest in access to your educational records and information (the &ldquo;</span><span>Educational Records</span><span>&rdquo;); and (B) in the U.S. the Recruiter may have access to such Educational Records subject to and in accordance with 34&nbsp;</span><span>F.R.</span><span>&nbsp;99.31(a)(1)(B);</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you will not solicit any immigration or visa related advice, at any stage of a visa application or proceeding (including prior to a visa application being made), from a Recruiter unless you have confirmed that the Recruiter complies with Applicable Law in the country to which you are applying and, if required, confirming that the Recruiter has a registration pursuant to such Applicable Law;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you will not pay a related fee or other consideration to any unauthorized Recruiters for any immigration or visa related advice unless they have confirmed to you that they are qualified under Applicable Law;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you will be solely responsible for all activities with respect to the Study Lancer Solution undertaken by you or your designates;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you will not use the Study Lancer Solution to provide commercial services to, or for the benefit of, any third party;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you have the right and the authority to enter into this Agreement, to grant the rights and licences referred to in this Agreement, to use the Study Lancer Solution, and to post or upload any content to Study Lancer&rsquo;s website or otherwise provide such content and Your Data to Study Lancer;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you have all legal rights necessary to use the Study Lancer Solution, both in the jurisdiction in which you are located and in the jurisdiction where the Study Lancer Partner you are applying to is located, including the right to access the Content, and the right to make the Application and provide Your Data;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you agree to obtain all authorizations necessary from all third parties for your use of any third-party data in conjunction with the Study Lancer Solution;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you will ensure that your use of the Study Lancer Solution does not interfere with, degrade, or adversely affect any software, system, network or data used by any person including Study Lancer and other users of the Study Lancer Solution (including by ensuring that you do not upload any viruses or other harmful code in using the Study Lancer Solution or by placing an undue burden upon the CPUs, servers or other resources used to provide the Study Lancer Solution);</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you will not in any way use the Study Lancer Solution to commit or attempt to commit a crime or facilitate the commission of any crime or other illegal or tortious acts, including any infringement of intellectual property rights, any fraudulent activities, any deceptive impersonation, or any activities that violate any third party&rsquo;s privacy rights;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you will not interfere with or in any manner compromise any of Study Lancer&rsquo;s security measures;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you will not alter, modify, delete, or otherwise interfere with or in any manner compromise any Content or features accessible through the Study Lancer Solution, including, the forms, Content delivery and display functionality of the Study Lancer website;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you will cooperate with Study Lancer and provide information requested by Study Lancer to assist Study Lancer and any Governmental or Regulatory Authorities in investigating or determining whether there has been a breach of this Agreement or Applicable Law; and</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you will comply with the terms and conditions of any agreements entered into between you and any third party (including the Study Lancer Partners, the service providers for any Internet services you use in conjunction with the Study Lancer Solution, and the hardware providers for any mobile device or other computing equipment through which you use the Study Lancer Solution), and to the extent that such agreements impose additional restrictions respecting your use of the Study Lancer Solution (whether by reason of usage limitations or otherwise), you will use the Study Lancer Solution in compliance with such restrictions.</span></p>
</li>
</ul>
<h2 dir="ltr"><span>8. Restrictions and Limitations on Your Use of the Study Lancer Solution</span></h2>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Access to Programs</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>You acknowledge that only certain Study Lancer Partners have agreements with Study Lancer to enable you to make an Application to such Study Lancer Partners through the Study Lancer Solution, and that not all educational study programs of such Study Lancer Partners may be offered as being Programs available to you using the Study Lancer Solution.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Usage Policies</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>The Study Lancer Solution will be subject to the usage policies as provided to you by Study Lancer from time to time, including in electronic form by posting on Study Lancer&rsquo;s website. Such policies may include limitations on data storage space, and equipment and/or software requirements. You are solely responsible for compliance with such policies.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Equipment</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>You are solely responsible for the selection, implementation, installation, maintenance and performance of any and all equipment, software and services used in conjunction with using the Study Lancer Solution (except for Study Lancer&rsquo;s computer systems and networks), including your choice and use of your Internet Service Provider.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Data Integrity and Back-up</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>You acknowledge and agree that Study Lancer cannot guarantee data integrity, and that it is solely your responsibility to back-up any of Your Data that you use in conjunction with the Study Lancer Solution.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Not for Time Sensitive Applications</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>The Study Lancer Solution is not developed or licensed for use in any inherently dangerous, time-sensitive, or mission critical manner.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Restrictions on Study Lancer Website Use</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>You will not:</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>copy, reproduce, modify, enhance, improve, alter, reverse engineer, disassemble, deconstruct, translate, decrypt, reverse compile or convert into human readable form the Study Lancer Solution, or any part thereof;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>distribute, assign, license, sublicense, lease, rent, transfer, sell or otherwise provide access to the Study Lancer Solution, in whole or in part, to any third party on a temporary or permanent basis;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>remove, deface, cover or otherwise obscure any proprietary rights notice or identification on the Content (including without limitation any copyright notice);</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>use the Solution in any way inconsistent with the use parameters for the Study Lancer Solution;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>attempt to hack the Study Lancer Solution or any communication initiated by or made through the Study Lancer Solution or to defeat or overcome any encryption or other technical protection methods implemented with respect to the Study Lancer Solution, data or Content or programming transmitted, processed or stored by Study Lancer or other users of the Study Lancer Solution;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>collect any information or communication about the users of the Study Lancer Solution, by monitoring, interdicting or intercepting any process of or communication initiated by the Study Lancer website or by developing or using any software or any other process or method that engages or assists in engaging in any of the foregoing;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>use any type of bot, spider, virus, clock, timer, counter, worm, software lock, drop dead device, packet-sniffer, Trojan-horse routing, trap door, time bomb or any other codes or instructions that are designed to be used to provide a means of surreptitious or unauthorized access to the Study Lancer Solution or any computer system or that are designed to monitor, distort, delete, damage or disassemble the Study Lancer Solution or its ability to communicate and perform the Services; or</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>authorize, permit or otherwise acquiesce in any other party engaging in any of the activities set forth in this Section 8, or attempting to do so.</span></p>
</li>
</ul>
</ul>
</ul>
<h2 dir="ltr"><span>Changes to Terms and Conditions; Changes to Study Lancer Solution; Right to Edit and Remove Your Data; Suspension or Termination</span></h2>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Changes to Terms and Conditions</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer reserves the right to change these Terms and Conditions at any time without notice. Your continued access to or use of the Study Lancer Solution after any changes to these Terms and Conditions indicates your acceptance of such changes. It is your responsibility to review these Terms and Conditions regularly.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Changes to the Study Lancer Solution</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer reserves the right to change, suspend or discontinue the Study Lancer Solution at any time, including the availability of any Content at any time, and from time to time, without notice offered by Study Lancer.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Right to Edit and Remove Your Data</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Notwithstanding anything to the contrary herein, Study Lancer reserves the right to review Your Data stored in files or programs on Study Lancer&rsquo;s servers to verify your compliance with this Agreement. Study Lancer has the right to edit or remove any of Your Data that, in Study Lancer&rsquo;s sole discretion, Study Lancer believes may be unlawful, obscene, abusive, or otherwise objectionable.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Suspension or Termination</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer may impose limits on the Study Lancer Solution or terminate or restrict your access to parts or all of the Study Lancer Solution without liability. Where feasible, Study Lancer will provide you with advance notice of such changes, limitations or discontinuance; however, you acknowledge that such notice may not be feasible in all circumstances, and that Study Lancer will have no liability whatsoever for its failure to provide such notice to you.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer reserves the right to revoke your access to the Study Lancer Solution for any abusive conduct or fraudulent use of the Study Lancer Solution and to cease the Study Lancer Solution temporarily or permanently, if your use of the Study Lancer Solution constitutes, in Study Lancer&rsquo;s sole discretion, a threat to Study Lancer or any third party&rsquo;s computer systems, networks, files, materials or other data, or a breach of this Agreement.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Without limiting other remedies, Study Lancer may limit your activity, issue a warning, temporarily suspend, indefinitely suspend or terminate your account and refuse to provide Study Lancer Solution to you if: (a) you breach this Agreement or the documents it incorporates by reference; (b) Study Lancer is unable to verify or authenticate any information you provides; or (c) Study Lancer believes that your actions may cause financial loss or legal liability for you, Study Lancer Partners, other users or Study Lancer. The above-described actions are not Study Lancer&rsquo;s exclusive remedies and Study Lancer may take any other legal, equitable or technical action it deems appropriate in the circumstances. Study Lancer will not have any liability to you or any third party in relation to the termination of this Agreement for any reason whatsoever.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Investigations</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer reserves the right to investigate suspected violations of this Agreement.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>You will cooperate with: (A) Governmental or Regulatory Authorities in the investigation of suspected criminal violations; (B) Study Lancer Partners investigating academic fraud or other misdemeanours, relating to your Application or otherwise; and (C) system administrators at Internet service providers, networks or computing facilities, and other content providers, in order to enable Study Lancer to enforce the terms and conditions of this Agreement.</span></p>
</li>
</ul>
</ul>
<h2 dir="ltr"><span>10. Your Obligation to Report Errors</span></h2>
<p dir="ltr"><span>You will promptly and accurately report to Study Lancer any actual or apparent errors, problems, nonconformities or other difficulties with the Study Lancer Solution, along with any other information reasonably requested by Study Lancer to aid in resolving such errors, problems, nonconformities or other difficulties, and hereby consent to the collection, processing, transmission and disclosure of such information by Study Lancer for the purposes of Study Lancer&rsquo;s internal use to improve the Study Lancer Solution or other Study Lancer products or services.</span></p>
<h2 dir="ltr"><span>11. Submissions</span></h2>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Any suggestions, bug reports or other communications respecting the functionality of the Study Lancer Solution or Study Lancer&rsquo;s website that you transmit to Study Lancer by any means (each, a &ldquo;</span><span>Submission</span><span>&rdquo;), are considered non-confidential and may be disseminated or used by Study Lancer or any third party without compensation or liability to you for any purpose whatsoever, whether for inclusion as part of the Study Lancer Solution or otherwise.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>You hereby grant Study Lancer, its affiliates and successors a perpetual, worldwide, non-exclusive, royalty-free, sublicensable and transferable license to use, copy, distribute, transmit, modify, develop, prepare derivative works of any Submission on, through or in connection with the Service, including for promoting, improving and developing the Study Lancer Solution. This provision does not apply to Personal Information that is subject to Study Lancer&rsquo;s Privacy Policy.</span></p>
</li>
</ul>
<h2 dir="ltr"><span>12. Fees, Payment and Taxes</span></h2>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Fees</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>You will pay all applicable fees in connection with the Study Lancer Solution, as set forth in Study Lancer&rsquo;s standard price list, as set forth on Study Lancer&rsquo;s website or as otherwise provided to you. Fees are quoted and payable in Canadian dollars for Canadian related Applications and USD U.S. related Applications.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer may require you to pay an Application processing deposit depending on the country from which you are applying, other characteristics applicable to applicants, and the related likelihood of an Application being successful due to Governmental or Regulatory Authority visa approvals. The details regarding the Application processing deposit and countries to which it will apply may be viewed on the Study Lancer website, and may be changed by Study Lancer from time to time. The situations where an Application processing deposit is refundable and situations where an Application processing deposit will NOT be returned to you are set out on the Study Lancer Website. THE SITUATIONS WHERE AN APPLICATION PROCESSING DEPOSIT WILL NOT BE RETURNED TO YOU INCLUDE THE FOLLOWING SITUATIONS, IF: (A) YOU FAIL TO PROVIDE THE REQUIRED DOCUMENTS TO PROCESS THE APPLICATION; (B) YOUR VISA APPLICATION IS REJECTED; OR (C) YOU CANCEL YOUR APPLICATION BEFORE AN ADMISSION DECISION IS RECEIVED.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Certain fees charged by Study Lancer under this Agreement are set by Study Lancer Partners or other third parties, and Study Lancer has no control over the fee amount, but simply remits such fee directly to the applicable Study Lancer Partner or third party, and that payment obligations are therefore non-cancellable and fees paid are non-refundable.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer reserves the right to modify such fees, upon reasonable notice, which may be performed by updating Study Lancer&rsquo;s standard price list, as set forth on Study Lancer&rsquo;s website.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Your use of the Study Lancer Solution following such changes constitutes your acceptance of any new or increased charges.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Fee Payment</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Where you pay fees by means of a credit card, you authorize Study Lancer or its third-party payment processor to automatically charge you for any and all fees incurred by you for Study Lancer Solution. If your credit card is rejected for any reason, you will be responsible for any fees and charges associated with such rejection.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>The foregoing will not limit Study Lancer&rsquo;s ability to exercise any rights available to it in law or equity respecting the collection of any amounts payable hereunder, and you will also be responsible for paying for all reasonable fees and costs incurred by Study Lancer, including legal fees, in collecting any overdue amounts or enforcing any provision of this Agreement.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Without limiting the foregoing, Study Lancer reserves the right not to process any Application or portion thereof prior to obtaining full payment of fees from you.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Interest on Late Payments</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>In addition to any other rights and remedies available to Study Lancer, Study Lancer will be entitled to charge interest on all outstanding amounts at the lesser of 1.5% per month or the maximum rate permitted by Applicable Law, such interest commencing as of the due date for such payment.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Taxes</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>You are responsible for, and will pay all taxes relating to this Agreement, excluding any taxes based on the net income of Study Lancer. Unless otherwise indicated, all amounts payable by you under this Agreement are exclusive of any tax, duty, levy, or similar government charge that may be assessed by any jurisdiction, whether based on gross revenue, the delivery, possession or use of the Study Lancer Solution, the execution of this Agreement or otherwise.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>If you are required to withhold any taxes from payments owed under this Agreement, the amount of payment due will automatically be increased to offset such tax, so that the amount actually remitted to Study Lancer will equal the amount due.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>You will promptly furnish Study Lancer with copies of all official receipts evidencing payment of taxes due under or in relation to this Agreement to the appropriate taxing authority.</span></p>
</li>
</ul>
</ul>
<h2 dir="ltr"><span>13. Confidential Information</span></h2>
<ul>
<li dir="ltr">
<p dir="ltr"><span>You must keep the terms of this Agreement and all information provided by Study Lancer confidential, except to the extent required to perform the Recruitment Services.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>You acknowledge that, during the course of the term of this Agreement, you may be exposed to Confidential Information.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>At all times during the Term and at all times following termination of this Agreement, whether voluntary or involuntary:</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>you will maintain all Confidential Information in strict confidence, will take all necessary precautions against unauthorized disclosure of the Confidential Information, and will not directly or indirectly, disclose, allow access to, transmit or transfer any Confidential Information to a third party without the knowledge and express written consent of Study Lancer;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you will not use, disclose or reproduce the Confidential Information except as reasonably required in the receipt of the Services and with the knowledge and express written consent of Study Lancer; and</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you will advise Study Lancer immediately in writing of any misappropriation, disclosure, conversion or misuse by any person of any Confidential Information of which you may become aware.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Subject to Study Lancer&rsquo;s ability to disclose Your Data as permitted under this Agreement, Study Lancer will use reasonable commercial endeavours to safeguard Your Data and keep it confidential, while Your Data is in Study Lancer&rsquo;s control, including implementing organisational and technical measures to protect your Personal Information. Study Lancer may also retain and disclose Your Data to: (i) Governmental or Regulatory Authorities to the extent required by Applicable Law: (ii) its professional advisors to the extent required to: (A) enable Study Lancer to fulfil its obligations pursuant to Applicable Law; or (B) defend or bring a claim relating to a breach of this Agreement.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>The nondisclosure obligations under this Agreement will not apply to information which a Party can establish:</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>is, or becomes, readily available to the public other than through a breach of this Agreement;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>was disclosed, lawfully and without breach of any contractual or other legal obligation, to a Party by a third party without any confidentiality obligation attached to such information;</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>was lawfully known to a Party without any confidentiality obligation prior to receipt of the information; or</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>was independently developed or discovered by a Party outside of the course of such Party&rsquo;s performance of their obligations under this Agreement, without any reference to any Confidential Information obtained directly or indirectly from the disclosing Party.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>You will immediately return to Study Lancer all Confidential Information which is in your possession or control upon the earlier of a request by Study Lancer or the termination of this Agreement (whether voluntary or involuntary).</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Damages may not be an adequate remedy to compensate Study Lancer for any breach of your obligations contained herein, and accordingly you agree that in addition to any and all other remedies available, Study Lancer will be entitled to obtain relief by way of a temporary or permanent injunction to enforce your obligations.</span></p>
</li>
</ul>
<h2 dir="ltr"><span>14. Intellectual Property</span></h2>
<p dir="ltr"><span>The Study Lancer Solution is owned by Study Lancer or its third-party licensors, who retain all right, title and interest therein. The Study Lancer Solution is protected by Canadian, U.S. and international copyright laws. In addition, other intellectual property laws (including patent laws) and treaties may protect the Study Lancer Solution.&nbsp;</span><span>You do not acquire any intellectual property or other proprietary rights under this Agreement, including any right, title or interest in and to patents, copyrights, trade-marks, industrial designs, confidential information, or trade secrets, whether registered or unregistered, relating to the Study Lancer Solution, or any part thereof. Any rights not expressly granted under this Agreement are reserved to Study Lancer or its third-party licensors.</span></p>
<h2 dir="ltr"><span>15. Term and Termination</span></h2>
<ul>
<li dir="ltr">
<p dir="ltr"><span>This Agreement will commence upon your acceptance of these Terms and Conditions on the Study Lancer website.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>This Agreement may be terminated by either Party for any reason, without cause, upon 30 days&rsquo; written notice addressed to the other Party.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>This Agreement may be terminated by Study Lancer immediately upon notice for cause if:</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>you commit a material breach of this Agreement and fail to rectify the breach within 30 calendar days of Study Lancer delivering notice of the breach; or</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>you commit a breach of any of your representations in this Agreement; or</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>if Study Lancer is prevented from providing any portion or all of the Study Lancer Solution due to: (A) your acts or omissions in breach of this Agreement; (B) acts or omissions of any third party (including any Study Lancer Partner); or (C) any Applicable Law or ruling issued in any form whatsoever by a Governmental or Regulatory Authority.</span></p>
</li>
</ul>
</ul>
<h2 dir="ltr"><span>16. Effect of Termination or Expiry</span></h2>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Upon any termination or expiry of this Agreement for any reason (whether by you or by Study Lancer), you must cease all use of the Study Lancer Solution.</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Termination or expiry of this Agreement, for any reason, will not affect your payment obligation for any fees accrued hereunder or payments owing prior to the effective date of termination or expiry.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>The termination of this Agreement by either Party does not affect any accrued rights or remedies of either Party.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Any provision of this Agreement which expressly states that it is to continue in effect after termination or expiration of this Agreement, or which by its nature would survive the termination or expiration of this Agreement, including this Section 16, will do so.</span></p>
</li>
</ul>
</ul>
<h2 dir="ltr"><span>17. Disclaimers</span></h2>
<ul>
<li dir="ltr">
<p dir="ltr"><span>DISCLAIMER OF IMPLIED WARRANTIES</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>THE Study Lancer SOLUTION, INCLUDING FOR GREATER CERTAINTY, THE CONTENT, AND REFERENCES, LINKS AND INFORMATION IN THE CONTENT, IS PROVIDED TO YOU &ldquo;AS IS&rdquo; WITHOUT WARRANTY OR CONDITIONS OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING THE IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, TITLE, NON-INFRINGEMENT, SECURITY OR ACCURACY.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>YOUR RELIANCE ON CONTENT</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer HAS NO SPECIAL RELATIONSHIP WITH OR FIDUCIARY DUTY TO YOU, AND YOU ACKNOWLEDGE THAT Study Lancer HAS NO CONTROL OVER, AND NO DUTY TO TAKE ANY ACTION REGARDING ANY ACTS OR OMISSIONS TAKEN BY YOU OR ANY OTHER USER OF THE Study Lancer SOLUTION, INCLUDING HOW YOU OR ANY OTHER USER MAY INTERPRET OR USE CONTENT ACCESSED OR DEVELOPED THROUGH THE Study Lancer SOLUTION, OR WHAT ACTIONS YOU MAY TAKE AS A RESULT OF HAVING BEEN EXPOSED TO CONTENT OBTAINED THROUGH THE Study Lancer SOLUTION.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>THE CONTENT ON THE Study Lancer SOLUTION INCLUDES REFERENCES TO THIRD PARTIES, INCLUDING THE Study Lancer PARTNERS, LINKS TO THIRD PARTY WEBSITES OR DOCUMENTS, AND INCORPORATES INFORMATION OBTAINED FROM THIRD PARTIES, INCLUDING Study Lancer PARTNERS. CONTENT MAY ALSO BE CREATED BY Study Lancer BASED ON SUCH THIRD PARTY INFORMATION, WHICH MAY CHANGE FROM TIME TO TIME WITHOUT NOTICE TO Study Lancer.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer ASSUMES NO RESPONSIBILITY FOR ANY ERRORS, OMISSIONS, INACCURACIES, EFFECTIVENESS, STANDARDS COMPLIANCE, COPYRIGHT COMPLIANCE, LEGALITY, DECENCY, OR ANY OTHER ASPECT OF THE CONTENT PROVIDED THROUGH THE Study Lancer SOLUTION.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>UNDER NO CIRCUMSTANCES WILL Study Lancer BE LIABLE FOR ANY LOSS OR DAMAGE CAUSED BY YOUR RELIANCE ON CONTENT OBTAINED THROUGH USE OF THE Study Lancer SOLUTION, INCLUDING ANY THIRD PARTY LINKED SITE (INCLUDING ANY OPINIONS, STATEMENTS OR ADVICE).</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>IT IS YOUR RESPONSIBILITY TO EVALUATE THE ACCURACY, COMPLETENESS AND USEFULNESS OF ANY CONTENT PROVIDED, AND USE OF THE Study Lancer SOLUTION IS SOLELY AT YOUR OWN RISK.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer WILL HAVE NO LIABILITY WHATSOEVER RESPECTING ANY CLAIM BY YOU OR ANY THIRD PARTY WHOSE CONTENT IS COLLECTED IN YOUR USE OF THE Study Lancer SOLUTION, WHETHER RELATED TO PRIVACY OR OTHERWISE, IN RELATION TO Study Lancer&rsquo;S USE OF YOUR DATA TO PROVIDE THE Study Lancer SOLUTION.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Control of Third Parties</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer has no control over Study Lancer Partners or any other entity granting visas, admissions, permits or other authorizations in connection with the Application; you acknowledge that the success of your Application is solely within the control of such third parties, not Study Lancer, and therefore release Study Lancer from all liability in relation to your Application.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Rejection of Applications</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer is not responsible in any way for your Application, mistakes in Your Data, or your failure to obtain entrance to your selected Program(s) or Study Lancer Partner(s).</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Issues with Study Lancer Partners</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>All issues respecting Applications, Programs, and your failure to comply with Study Lancer Partner policies, are solely as between you and the applicable Study Lancer Partner, and Study Lancer bears no responsibility or liability in relation to such matters.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Inability to Access Country</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>You are solely responsible for fulfilling any entry requirements necessary to gain admission into the country where your Program is located in compliance with Applicable Law and any requirements of Governmental or Regulatory Authorities.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Service Providers</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Although Study Lancer has made reasonable efforts to verify that its agreements with its service providers are reasonably protective of Your Data, you acknowledge that Study Lancer has no liability for any acts or omissions of third parties in relation to such servers and the data stored on them. You therefore hereby release Study Lancer from all liability for any governmental or third party action taken in such jurisdictions with respect to such information and data or the servers on which Your Data resides, and you acknowledge that you retain sole responsibility to back up and retain copies of such information and data.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Unauthorized use of Access Information</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer is not responsible or liable in any way for any use of the Study Lancer Solution (authorized or unauthorized) by any third party accessing the Study Lancer Solution using your Access Information, and you accept all responsibility for such use of the Study Lancer Solution and any consequences resulting from such use of the Study Lancer Solution.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Use for Time Sensitive Applications</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>You agree that Study Lancer will not be liable for any claims or damages arising from such use if you use the Study Lancer Solution for a time sensitive use.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Availability of the Study Lancer Solution</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer WILL HAVE NO LIABILITY WHATSOEVER TO YOU OR ANY PARTY CLAIMING BY OR THROUGH YOU FOR THE TIMELINESS OR CONTINUED AVAILABILITY OF THE Study Lancer SOLUTION.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Applicable Law</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Some jurisdictions do not allow the exclusion of certain warranties or liability, so the above limitations or exclusions may not apply to you.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Viruses</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>The downloading and viewing of Content is done at your own risk. Study Lancer cannot and does not guarantee or warrant that the Study Lancer Solution or the Content are compatible with your computer system or that the Study Lancer Solution, or any links from the Study Lancer Solution or the Content, will be free of viruses, worms, trojan horses or disabling devices or other code that manifests contaminating or destructive properties. You are responsible for implementing safeguards to protect the security and integrity of your computer system, and your are responsible for the entire cost of any service, repairs or connections of and to your computer system that may be necessary as a result of your use of the Study Lancer Solution.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Communications Not Confidential or Secure</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Study Lancer does not guarantee the confidentiality of any communications made by your through the Study Lancer Solution, over the internet or over the telephone. Although Study Lancer generally adheres to the accepted industry practices in securing the transmission of data to, from and through the Study Lancer Solution, you understand, agree and acknowledge that Study Lancer cannot and does not guarantee the security of data transmitted over the Internet or public networks in connection with your use of the Study Lancer Solution.</span></p>
</li>
</ul>
</ul>
<h2 dir="ltr"><span>18. Your Indemnities</span></h2>
<p dir="ltr"><span>You will indemnify, defend and hold harmless Study Lancer, and all of its officers, directors, employees and agents, its parent company, subsidiaries and affiliates, from and against any claims, causes of action, demands, recoveries, losses, damages, fines, penalties or other costs or expenses of any kind or nature, including reasonable legal and accounting fees, directly or indirectly due to, arising out of or in connection with:</span></p>
<ul>
<li dir="ltr">
<p dir="ltr"><span>your access to the Study Lancer Solution, and any reliance on any Content obtained by you through the Study Lancer Solution; or</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>your unauthorized use or misuse of the Study Lancer Solution; or</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>your breach of this Agreement; or</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>the infringement, violation or misappropriation by you, or any third-party obtaining access to the Study Lancer Solution through your Access Information, of any intellectual property or other right of any third person or entity; or</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Your violation of any Applicable Laws.</span></p>
</li>
</ul>
<h2 dir="ltr"><span>19. Limitation of Liability</span></h2>
<ul>
<li dir="ltr">
<p dir="ltr"><span>To the maximum extent permitted under Applicable Law, in no event will Study Lancer be liable, whether based on warranty, contract, tort, negligence, strict liability or any other legal theory, for any indirect, incidental, consequential, special, exemplary or punitive damages, lost profits, loss of use, loss of data, personal injury, fines, fees, penalties or other liabilities, whether or not Study Lancer is advised of the possibility of such damages, resulting from or related to the use of, or the inability to make use of, the Study Lancer Solution.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>To the maximum extent permitted under Applicable Law, in no event will the total aggregate liability of Study Lancer in connection with or under this Agreement or your use of, or inability to make use of, the Study Lancer Solution, or for any other claim related in any way to your use of, or inability to make use of, the Study Lancer Solution exceed the sum of \$1,000 US dollars. For greater certainty, the existence of one or more claims under this Agreement will not increase the maximum liability amount.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Nothing in this Agreement limits Study Lancer&rsquo;s liability for fraud, personal injury or death to the extent found to be caused by Study Lancer&rsquo;s negligence or willful misconduct.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>The limitations in this Section reflect the allocation of risk between the Parties. The limitations specified in this Section will survive and apply even if any limited remedy specified in this Agreement is found to have failed of its essential purpose.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>SOME JURISDICTIONS DO NOT ALLOW THE LIMITATION OR EXCLUSION OF LIABILITY FOR INCIDENTAL OR CONSEQUENTIAL DAMAGES SO THE ABOVE LIMITATIONS OR EXCLUSIONS MAY NOT APPLY TO YOU.</span></p>
</li>
</ul>
<h2 dir="ltr"><span>20. General</span></h2>
<p dir="ltr"><span>Except as otherwise provided herein, the Parties rights and remedies under this Agreement are cumulative. The terms &ldquo;include&rdquo; and &ldquo;including&rdquo; mean, respectively, &ldquo;include without limitation&rdquo; and &ldquo;including without limitation.&rdquo; The headings of sections of this Agreement are for reference purposes only and have no substantive effect. Any rule of construction to the effect that any ambiguity in this Agreement will be resolved against the drafting party will not be applied to the interpretation of this Agreement.</span></p>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Force Majeure</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Neither Party will be liable for delays caused by any event beyond its reasonable control, except non-payment of amounts due under this Agreement will not be excused by this provision.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Contracting Status</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Nothing contained in this Agreement will be construed to create or imply a joint venture, partnership, principal-agent, or employment relationship between the Parties. Except as expressly authorized by Study Lancer in writing, you will neither act nor purport to be acting as the legal agent of Study Lancer, nor enter into any agreement on behalf of Study Lancer or otherwise bind or purport to bind Study Lancer in any manner whatsoever.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Notices</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>Any notices, reports or other communications required or permitted to be given under this Agreement will be in writing, including email, and will be sufficient if delivered by hand or sent by registered mail, courier or facsimile addressed to you or Study Lancer at the respective addresses as advised in writing. Any such notices, reports, or other communications will be deemed to have been received by the Party to whom they were addressed: (i) upon delivery by hand, (ii) five business days after being sent by registered mail, (iii) upon delivery by courier, as evidenced by the courier receipt, (iv) upon successful receipt confirmation report after being sent by facsimile; or (v) if sent by email, upon receipt by the sender of a delivery receipt confirmation.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>No Waiver</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>No waiver by either Party of a breach or omission by the other party under this Agreement will be binding on the waiving Party unless it is expressly made in writing and signed by the waiving Party. Any waiver by a Party of a particular breach or omission by the other Party will not affect or impair the rights of the waiving party in respect of any subsequent breach or omission of the same or different kind.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Severability</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>If any one or more of the provisions of this Agreement will for any reason be held to be invalid, illegal, or unenforceable in any respect, any such provision will be severable from this Agreement, in which event this Agreement will be construed as if such provision had never been contained herein.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Governing Law</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>This Agreement will be governed by and construed under the laws of the Province of Ontario, Canada. The Parties hereby waive any right to a trial by jury with respect to any lawsuit or judicial proceeding arising or relating to this Agreement. In construing, interpreting and enforcing this Agreement, choice of law principles will not apply. The Study Lancer Solution are intended for use only in jurisdictions where they may be lawfully offered for use.</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Except as restricted by Applicable Law, Recruiter hereby consents to the exclusive jurisdiction and venue of courts in Punjab, Haryana High court India&nbsp; in all disputes arising out of or relating to the use of the Study Lancer Solution.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Entire Agreement/Modification</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>This Agreement constitutes the entire agreement between the Parties and supersedes all previous agreements and understandings relating to the subject matter hereof. This Agreement may not be altered, amended, or modified except by a written instrument signed by the duly authorized representatives of both Parties.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>Electronic Agreement</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>You acknowledge and agree that by clicking on the &ldquo;I AGREE&rdquo; button (or similar buttons or links as may be designated by Study Lancer to show your acceptance of this Agreement and/or your agreement to use the Study Lancer Solution), you are entering into a legally binding contract. You hereby agree to the use of electronic communication in order to enter into contracts, place orders and create other records and to the electronic delivery of notices, policies and records of transactions initiated or completed through the Study Lancer Solution, including the Application. Furthermore, you hereby waive any rights or requirements under any Applicable Laws in any jurisdiction which require an original (non-electronic) signature or delivery or retention of non-electronic records, to the extent permitted under Applicable Law. A printed version of this Agreement and of any notice given in electronic form will be admissible in judicial or administrative proceedings based upon or relating to this Agreement to the same extent and subject to the same conditions as other business documents and records originally generated and maintained in printed form.</span></p>
</li>
</ul>
<li dir="ltr">
<p dir="ltr"><span>English language</span></p>
</li>
<ul>
<li dir="ltr">
<p dir="ltr"><span>It is the express will of the Parties that this Agreement and all related documents have been drawn up in English.&nbsp;</span><span>C&rsquo;est la volont&eacute; expresse des parties que la pr&eacute;sente convention ainsi que les documents qui s&rsquo;y rattachent soient r&eacute;dig&eacute;s en anglais.</span></p>
</li>
</ul>
</ul>
<h2 dir="ltr"><span>21. Contact</span></h2>
<p dir="ltr"><span>Any questions regarding this Agreement, or any questions, complaints, claims or other legal concerns relating to Study Lancer or its business, should be directed to Study Lancer at:</span></p>
<p dir="ltr"><a><span>info@Study Lancer.com</span></a></p>
<p dir="ltr">&nbsp;</p>
                      """,
                      style: {'Html': Style(color: Colors.white)},
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
