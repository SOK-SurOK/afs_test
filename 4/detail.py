import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
big_data = pd.read_csv("test.csv", delimiter=',')
big_data = big_data.rename(columns={
    "Month_of_2020": "month_of_2020", "Game name": "game_name", "Payment System": "payment_system",
    "User country": "user_country", "Incomplete attempts": "incomplete_attempts",
    "Completed payments": "completed_payments", "AFS reject": "AFS_reject",
    "PS declines": "PS_declines", "Refunds": "refunds"
})

game1 = big_data[big_data["game_name"] == " Funny squirrel"].drop("game_name", 1)
game2 = big_data[big_data["game_name"] == " Funny squirrel in Space"].drop("game_name", 1)
game1_month_list = []
game2_month_list = []
for i in range(5):
    game1_month_list.append(game1[game1["month_of_2020"] == i+1 ].drop("month_of_2020", 1))
    game2_month_list.append(game2[game2["month_of_2020"] == i+1 ].drop("month_of_2020", 1))


######################################################################################################

# pd.DataFrame({'user_country': y0.user_country, 'incomplete_attempts':y0.incomplete_attempts})


bar0 = game1_month_list[0].groupby("user_country", as_index = False).sum()
bar0 = bar0.rename(columns={
    # "payment_system","user_country", 
    "incomplete_attempts": "incomplete_attempts_1",
    "completed_payments": "completed_payments_1",
    "AFS_reject": "AFS_reject_1",
    "PS_declines": "PS_declines_1",
    "refunds": "refunds_1"
})
for i in range(1, len(game1_month_list)):
    bar = game1_month_list[i].groupby("user_country", as_index = False).sum()
    bar = bar.rename(columns={
        # "payment_system","user_country", 
        "incomplete_attempts": "incomplete_attempts_"+str(i+1),
        "completed_payments": "completed_payments_"+str(i+1),
        "AFS_reject": "AFS_reject_"+str(i+1),
        "PS_declines": "PS_declines_"+str(i+1),
        "refunds": "refunds_"+str(i+1)
    })
    bar0 = bar0.merge(bar, how = 'outer', left_on='user_country', right_on='user_country') 
bar0 = bar0.sort_values("user_country")


bar0.plot(x="user_country", kind="bar", title="изменение для стран по месяцам", fontsize=6, y=[
    "AFS_reject_1", "AFS_reject_2", "AFS_reject_3", 
    "AFS_reject_4", "AFS_reject_5"
])
"""
bar0.plot(x="user_country", kind="bar", title="изменение для стран по месяцам", fontsize=6, y=[
    "PS_declines_1", "PS_declines_2", "PS_declines_3", 
    "PS_declines_4", "PS_declines_5"
])
bar0.plot(x="user_country", kind="bar", title="изменение для стран по месяцам", fontsize=6, y=[
    "refunds_1", "refunds_2", "refunds_3", 
    "refunds_4", "refunds_5"
])
"""
#########################################################################################################
plt.show()

