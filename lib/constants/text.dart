const String projectDescriptionAr = '''
المشروع عبارة عن منظومة متكاملة لإدارة الملفات مصممة لتلبية احتياجات المستخدمين في بيئة عمل تعاونية، مع دعم لتخصيص واجهة المستخدم. فيما يلي شرح تفصيلي للميزات:

---

### **1. إدارة المجموعات:**
#### **إنشاء المجموعات:**
- يمكن **لصاحب المجموعة** إنشاء مجموعات جديدة وتسمية كل مجموعة.
- كل مجموعة تحصل على معرف فريد (UUID) لضمان التمييز.

#### **إضافة الملفات إلى المجموعات:**
- يمكن لأعضاء المجموعة رفع الملفات (وثائق، صور، فيديوهات) إلى المجموعة.
- يتم تنظيم الملفات حسب المجموعات لتسهيل الوصول.

#### **إدارة العضويات:**
- يمكن لصاحب المجموعة دعوة الآخرين للانضمام إلى المجموعة.
- **طريقة الدعوة:** إرسال رابط دعوة أو دعوة مباشرة عبر البريد الإلكتروني أو رقم الهاتف.

---

### **2. التحكم في الصلاحيات:**
#### **دعوات المجموعات:**
- فقط صاحب المجموعة يمكنه دعوة الآخرين للانضمام.
- يمكن للأعضاء الجدد عرض الملفات المرفوعة والمشاركة في إدارة المجموعة بناءً على الصلاحيات.

#### **قفل الملفات:**
- **ميزة رئيسية:**
  - عند فتح ملف داخل المجموعة، يتم قفله تلقائيًا.
  - القفل يمنع باقي الأعضاء من فتح أو تعديل الملف أثناء استخدامه.
  - **فتح القفل:** يتم عند إغلاق الملف أو تحرير القفل يدويًا.

---

### **3. دعم التخصيص:**
#### **تبديل الثيم:**
- يمكن للمستخدمين التبديل بين **الوضع الفاتح** و **الوضع الداكن**.
- يتم حفظ إعدادات الثيم لكل مستخدم بشكل فردي (في قاعدة البيانات أو SharedPreferences).

#### **تبديل اللغة:**
- يدعم النظام التبديل بين اللغة العربية والإنجليزية.
- إعدادات اللغة ديناميكية ويمكن تغييرها من الواجهة.

---

### **4. تصدير التقارير:**
- **فقط صاحب المجموعة** يمتلك صلاحية تصدير التقارير.
- **أنواع التقارير:**
  - **تقارير الملفات:** قائمة بجميع الملفات في المجموعة مع تفاصيلها (اسم الملف، تاريخ الرفع، من قام بالرفع، حالة القفل).
  - **تقارير العضوية:** تفاصيل أعضاء المجموعة (اسم العضو، تاريخ الانضمام، عدد الملفات المرفوعة).

#### **تنسيقات التقارير:**
- يمكن تصدير التقارير بتنسيقات مثل PDF أو Excel.
- يمكن تنزيل التقارير مباشرة أو إرسالها عبر البريد الإلكتروني.

---

### **5. تجربة المستخدم:**
#### **واجهة بسيطة وسهلة الاستخدام:**
- تم تصميم الواجهة لتكون بديهية للمستخدمين.
- **شاشة المجموعات:**
  - قائمة بجميع المجموعات التي ينتمي إليها المستخدم.
  - إمكانية إنشاء مجموعة جديدة.

#### **واجهة الملفات:**
- عرض الملفات المرفوعة بشكل منظم.
- تصفية الملفات حسب النوع أو تاريخ الرفع.

#### **الإعدادات الشخصية:**
- إدارة الثيمات.
- تغيير اللغة.
- عرض وإدارة الملفات المغلقة.

---

### **6. السيناريوهات المحتملة:**
#### **إضافة عضو جديد إلى المجموعة:**
1. يرسل صاحب المجموعة دعوة للمستخدم.
2. يقبل المستخدم الدعوة وينضم إلى المجموعة.
3. يمكن للمستخدم عرض الملفات المشتركة بناءً على الصلاحيات الممنوحة.

#### **رفع ملف جديد:**
1. يحدد المستخدم المجموعة التي يرغب برفع الملف إليها.
2. يرفع المستخدم الملف ويضيف بياناته (مثل العنوان والوصف).
3. يصبح الملف متاحًا لجميع الأعضاء بناءً على الصلاحيات.

#### **قفل ملف:**
1. يفتح أحد الأعضاء ملفًا معينًا.
2. يتم قفل الملف تلقائيًا لمنع الآخرين من تعديله أو حذفه.
3. يتم إزالة القفل عند إغلاق الملف.

---

### **التقنيات المستخدمة:**
#### **الواجهة الأمامية:**
- **Flutter** لبناء واجهة المستخدم ودعم التخصيص.
- مكتبات مثل **provider** أو **bloc** لإدارة الحالة.

#### **الخلفية:**
- **Django** أو **Node.js** لإدارة قاعدة البيانات والخادم.
- خيارات قواعد البيانات مثل **PostgreSQL** أو **MongoDB**.

#### **التخزين والتقارير:**
- تخزين الملفات باستخدام **Amazon S3** أو **Firebase Storage**.
- إنشاء التقارير باستخدام مكتبات مثل **ReportLab** أو **xlsxwriter**.

---

### **الخلاصة:**
تم تصميم النظام ليكون مرنًا وقويًا، لدعم العمل الجماعي والتخصيص، مع توفير أدوات لإدارة الملفات والمجموعات بكفاءة.
''';

const String projectDescriptionEn = '''
The project is a comprehensive file management system designed to meet user needs in a collaborative work environment, with support for interface customization. Here's a detailed explanation step by step:

---

### **1. Group Management:**
#### **Creating Groups:**
- The **group owner** can create new groups and name them.
- Each group has a unique identifier (UUID) to ensure distinction.

#### **Adding Files to Groups:**
- Members of a group can upload files (Documents, Images, Videos) to the group.
- Files are organized by groups to facilitate easy access.

#### **Membership Management:**
- The group owner can invite others to join the group.
- **Invitation Method:** Sending an invitation link or direct invite via email or phone number.

---

### **2. Permissions Control:**
#### **Group Invitations:**
- Only the group owner can invite others to join the group.
- New members can view the uploaded files and participate in managing the group based on their permissions.

#### **File Locking:**
- **Key Feature:** 
  - When a user opens a file in the group, it is automatically locked.
  - The lock prevents other members from opening or modifying the file while it is in use.
  - **Unlocking:** Happens when the user closes the file or manually releases the lock.

---

### **3. Customization Support:**
#### **Theme Switching:**
- Users can switch between **light mode** and **dark mode**.
- Theme settings are saved for each user individually (in the database or SharedPreferences).

#### **Language Switching:**
- The system supports switching between Arabic and English.
- Language settings are dynamic and can be changed from the interface.

---

### **4. Report Exporting:**
- **Only the group owner** has the authority to export reports.
- **Types of Reports:**
  - **File Reports:** A list of all files in the group with their details (file name, upload date, uploaded by, lock status).
  - **Membership Reports:** Details of group members (member name, join date, number of files uploaded).

#### **Report Formats:**
- Reports can be exported in formats such as PDF or Excel.
- Reports can either be downloaded directly or sent via email.

---

### **5. User Experience:**
#### **Simple and User-Friendly Interface:**
- The interface is designed to be intuitive for users.
- **Groups Screen:**
  - A list of all groups the user is a part of.
  - Ability to create a new group.

#### **Files Interface:**
- Display uploaded files in an organized manner.
- Filter files by type or upload date.

#### **Personal Settings:**
- Manage themes.
- Change language.
- View and manage locked files.

---

### **6. Potential Scenarios:**
#### **Adding a New Member to a Group:**
1. The group owner sends an invitation to the user.
2. The user accepts the invitation and joins the group.
3. The user can view shared files based on the permissions given.

#### **Uploading a New File:**
1. The user selects the group to which they want to upload the file.
2. The user uploads the file and adds its metadata (e.g., title, description).
3. The file becomes accessible to all members based on their permissions.

#### **Locking a File:**
1. A member opens a specific file.
2. The file is automatically locked, preventing others from modifying or deleting it.
3. The lock is removed once the file is closed.

---

### **Technologies Used:**
#### **Frontend:**
- **Flutter** for building the user interface and supporting customization.
- Libraries like **provider** or **bloc** for state management.

#### **Backend:**
- **Django** or **Node.js** for database and server management.
- Database options like **PostgreSQL** or **MongoDB**.

#### **Storage and Reporting:**
- File storage using **Amazon S3** or **Firebase Storage**.
- Report generation with libraries like **ReportLab** or **xlsxwriter**.

---

### **Summary:**
The system is designed to be flexible and robust, supporting teamwork and customization while providing tools for managing files and groups efficiently.
''';

const String aboutUsAr = """
مرحبًا بكم في تطبيقنا! 
\nنحن فريق مكرس لتقديم أفضل الخدمات لمستخدمينا. 
\nهدفنا هو إنشاء حلول مبتكرة وسهلة الاستخدام تلبي احتياجاتكم. 
\nنحن ملتزمون بتحسين تجربتكم باستمرار وجعلها أكثر فعالية وراحة.
""";

const String aboutUsEn = """
Welcome to our application! 
\nWe are a team dedicated to providing the best services to our users. 
\nOur goal is to create innovative and user-friendly solutions tailored to your needs. 
\nWe are committed to continuously improving your experience and making it more efficient and convenient.
""";
