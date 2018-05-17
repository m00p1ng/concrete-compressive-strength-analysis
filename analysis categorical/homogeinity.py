import pandas as pd

df = pd.read_csv('../concrete.csv')

cement_group = [
    (100, 200),
    (200, 300),
    (300, 400),
    (400, 500),
    (500, 999)
]

age_group = [
    (0, 7),
    (7, 30),
    (30, 90),
    (90, 999)
]

my_list = [[0]*4 for i in range(5)]
for i, c in enumerate(cement_group):
    for j, a in enumerate(age_group):
        my_list[i][j] = len(df[(df['cement'] > c[0]) & (df['cement'] <= c[1]) & (df['age'] > a[0]) & (df['age'] <= a[1])])
        

row_sum = [sum(i) for i in my_list]

col_sum = [sum(i[j] for i in my_list) for j in range(len(my_list[0]))]

expected = [[0]*4 for i in range(5)]
total = sum(row_sum)

for i in range(len(row_sum)):
    for j in range(len(col_sum)):
        expected[i][j] = row_sum[i]*col_sum[j]/total

result = [[(my_list[i][j] - expected[i][j])**2/expected[i][j] for j in range(len(my_list[0]))] for i in range(len(my_list))]

test_stat = sum([sum(i) for i in result])