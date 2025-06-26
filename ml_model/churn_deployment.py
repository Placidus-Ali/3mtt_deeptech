# Import Libraries
import streamlit as st
import pandas as pd
import joblib 
from PIL import Image
print('Libraries Imported Successfully')

# Load Model
import os
model_path = os.path.join(os.path.dirname(__file__), 'gb_model.pkl')
model = joblib.load(model_path)


#model = joblib.load('gb_model.pkl')
print('Model Loaded Successfully')

# Set Stremlit Title and Header
st.title('Telecom Customer Churn Prediction')
image = Image.open('Telecoms.jpeg') 
st.image(image, use_column_width=True)
st.write('This Application predicts whether a telecom customer is likely to churn based on some attributes')
st.header('Kindly Provide the Following Information')
with st.expander("Documentation: Input Feature Descriptions"):
    st.markdown("""
    **Account Weeks**: Number of weeks the customer has had an account with the company.
    **Contract Renewal**: Whether the customer has recently renewed their contract (1 = Yes, 0 = No).
    **Data Plan**: Whether the customer has a mobile data plan (1 = Yes, 0 = No).
    **Data Usage**: Amount of mobile data used by the customer in GB.
    **Customer Service Calls**: Number of calls made by the customer to customer service.
    **Day Minutes**: Total number of minutes used during the day.
    **Day Calls**: Number of calls made during daytime hours.
    **Monthly Charge**: Monthly fee the customer pays.
    **Overage Fee**: Extra charges for exceeding plan limits.
    **Roaming Minutes**: Number of minutes spent on roaming.
    """)
print('Streamlit Title and Header Set Successfully')

# Define Input Paramters
account_weeks = st.number_input('Account Weeks', min_value=1, max_value=243, value=10)
contract_renewal = st.selectbox('Contract Renewal', options=[0,1], format_func=lambda x: "Yes" if x== 1 else "No")
data_plan = st.selectbox('Data Plan', options=[0,1], format_func=lambda x: "Yes" if x== 1 else "No")
data_usage = st.number_input('Data Usage', min_value=0.0, max_value=5.4, value=2.0, step=0.1)
cust_serv_calls = st.number_input('Customer Service Calls', min_value=0, max_value=9, value=2)
day_mins = st.number_input('Day Minutes', min_value=0.0, max_value=350.8, value=150.0, step=0.1)
day_calls = st.number_input('Day Calls', min_value=0, max_value=165, value=80)
monthly_charge = st.number_input('Monthly Charge', min_value=14.0, max_value=111.3, value=70.0, step=0.1)
overage_fee = st.number_input('Overage Fee', min_value=0.0, max_value=18.2, value=5.0, step=0.1)
roam_mins = st.number_input('Roaming Minutes', min_value=0.0, max_value=20.0, value=5.0, step=0.1)
print('Input Parameters Created Successfully')


# Create a dictionary from the imput parameter
input_data = {
'AccountWeeks': account_weeks,
'ContractRenewal': contract_renewal,
'DataPlan': data_plan,
'DataUsage': data_usage,
'CustServCalls': cust_serv_calls,
'DayMins': day_mins,
'DayCalls': day_calls,
'MonthlyCharge': monthly_charge,
'OverageFee': overage_fee,
'RoamMins': roam_mins
} 
print('Dictionary Created Successfully')


# Convert the Dictionary to a Pandas DataFrame
input_df = pd.DataFrame([input_data])
print('DataFrame Created Successfully')

# Make Predictions
if st.button('Predict Churn'):
    try:
        prediction = model.predict(input_df)
        st.subheader('prediction Result')
        if prediction[0] == 1:
            st.error(f'This Customer is likely to CHURN')
        else:
            st.success(f' This Customer is likely to STAY')
    except Exception as e:
        st.error(f"An error occurred during prediction: {e}")
print('Model Deployed Successfully')