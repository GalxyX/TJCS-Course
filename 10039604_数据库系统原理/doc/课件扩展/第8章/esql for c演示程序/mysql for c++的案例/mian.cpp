#include <Windows.h>
#include <stdlib.h>
#include <string>
#include <mysql.h> 
#include <iostream>

#include <vector>
using namespace std;
typedef vector<char *> ColName; 
int main()
{
	/*-------------------------------------
	 *   �洢Ҫ�������ݿ�ı�Ҫ��Ϣ       *
	--------------------------------------*/

    const char user[] = "root";          //username
    const char pswd[] = "940923";        //password
    const char host[] = "localhost";     //or"127.0.0.1"
    const char table[] = "course_ex";        //database
    unsigned int port = 3306;            //server port        

    //����һ��mysql����
	MYSQL mytest;
	//��ʼ�����ݿ����
	mysql_init(&mytest);
		
	ColName array1;

    int res;

    if(mysql_real_connect(&mytest ,host ,user ,pswd ,table ,port ,NULL ,0))
		//�������ݿⲢ���ڳɹ����ӵ�����½��в���
    {
        cout<<"����" << host << "-" << table << "�ɹ�" <<endl;

        mysql_query(&mytest, "SET NAMES GBK"); //���ñ����ʽ

		string tmpquery = "";

		char query[100] = "";

		MYSQL_ROW sql_row;//��������Ϣ

		MYSQL_FIELD *fd;//��������Ϣ
    
		do
		{
			cout << "���� mysql ��� :" << endl;
			getline(cin ,tmpquery);

			//������������
			int i = 0 ,j = 0;
			while(i < tmpquery.length())
			{
				query[i] = tmpquery[i];
				i ++;
			}

			//�����������ı���
			MYSQL_RES *dynamic_query;

			res = mysql_query(&mytest ,query);						
			if(!res)
			{
				cout << "�����ѳɹ�ִ��" << endl;
				if(tmpquery.substr(0,6) == "select")
				{
					dynamic_query = mysql_store_result(&mytest);
					if(dynamic_query)
					{					
						for(i = 0 ;fd = mysql_fetch_field(dynamic_query) ;i++)//��ȡ����(�����ƶ��α�)
							array1.push_back(fd->name);

						j = mysql_num_fields(dynamic_query);   

						while(sql_row = mysql_fetch_row(dynamic_query))//��ȡ���������
						{
							for(i = 0;i < j; i++)
							{
								cout << array1[i]  << "-" << sql_row[i] << endl;
                                ��mysql���󷵻صĽ���������ַ�����ʽ�����
								string tmptest = sql_row[i];

							}                   
						}
						if(dynamic_query != NULL) 
							mysql_free_result(dynamic_query);
					}
					else					
						cout << "��ѯ���ݳ���" << endl;		
				}
				else
				{
					cout << "�������!" << endl;
				}				
			}
			else if(query[0] == '0')
			{
				cout << "�����˳�!" << endl;
				break;
			}
			else
			{
				cout << "����ִ��ʧ��" << endl;
			}
			res = 0;
		}while(1);
	}
	else
		cout << "���ݿ�����ʧ��,�����˳���" << endl;
    mysql_close(&mytest);//�Ͽ�����
    return 0;
}
