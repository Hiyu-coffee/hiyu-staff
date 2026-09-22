HIYU 員工店務系統 V1
========================
功能：
1. 員工登入
2. 上班打卡後自動跳至今日公告
3. 公告已讀紀錄
4. 今日工作事項
5. 查看自己的排班
6. 請假申請
7. 出勤異動申請
8. 下班打卡後可填今日交班
9. 現金／LINE Pay／其他支付／支出／現金差額
10. 管理端查看員工、今日出勤、待審核、公告、工作事項、今日交班
11. 出勤 CSV 匯出

部署前：
A. 先在 Supabase SQL Editor 執行 hiyu_employee_v1.sql
B. config.js 已放入專案 URL；請把 Publishable Key 填入
C. 建立員工 Auth 帳號，並讓 employees.auth_user_id 對應該 Auth user id
D. 將整個資料夾部署到新的 Vercel 專案

注意：
- 本系統與既有 HIYU V5 訂位／桌況系統分開。
- 管理端目前以 authenticated 帳號作為權限基礎；正式營運前建議再建立 admin/employee role RLS。
Vercel deployment trigger
