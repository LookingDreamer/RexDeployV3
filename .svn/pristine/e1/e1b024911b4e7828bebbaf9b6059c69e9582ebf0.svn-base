#!/usr/bin/env python
# coding=utf-8
import sqlite3
import json
import sys

class OpRecordQuery(object):
    def __init__(self):
        self.cx = sqlite3.connect("../db/op_record.db")

    # 查询记录, 如果op_date_start为0, 则表示dump出全部记录
    # 如果op_date_start不为0, op_date_end位0, 则表示到处某天记录
    # 如果op_date_start和op_date_end都不为0, 表示导出一段时间范围的记录
    def query(self, op_date_start, op_date_end=0):
        assert isinstance(op_date_start, int)
        assert isinstance(op_date_end, int)
        if (op_date_start == 0):
            sql_query_record = u'select * from op_record'
        elif (op_date_start != 0 and op_date_end == 0):
            sql_query_record = u'select * from op_record where op_date = %d' %  op_date_start
        else:
            sql_query_record = u'''
            select * from op_record where op_date >= %d and op_date <= %d
            ''' % (op_date_start, op_date_end)
        cursor = self.cx.execute(sql_query_record)
        query_ret = [] 
        for element in cursor:
            record                           = {}
            record['id']                     = element[0]
            record['op_date']                = element[1]
            record['start_time']             = element[2]
            record['end_time']               = element[3]
            record['op_sum_cnt']             = element[4]
            record['op_ok_cnt']              = element[5]
            record['op_fail_cnt']            = element[6]
            record['op_status']              = element[7]
            record['create_folder_sum_cnt']  = element[8]
            record['create_folder_ok_cnt']   = element[9]
            record['create_folder_fail_cnt'] = element[10]
            record['upload_file_sum_cnt']    = element[11]
            record['upload_file_ok_cnt']     = element[12]
            record['upload_file_fail_cnt']   = element[13]
            record['del_folder_sum_cnt']     = element[14]
            record['del_folder_ok_cnt']      = element[15]
            record['del_folder_fail_cnt']    = element[16]
            record['del_file_sum_cnt']       = element[17]
            record['del_file_ok_cnt']        = element[18]
            record['del_file_fail_cnt']      = element[19]
            query_ret.append(record)
        return json.dumps(query_ret, sort_keys=True, indent=4)

if __name__ == '__main__':
    record_query=OpRecordQuery()
    if (len(sys.argv) > 3):
        useage_str = u'''
        query record of one day: op_record_query.py op_date\n
        query record from one day to another day: op_record_query.py start_day end_day\n
        query all record: op_record_query.py
        '''
        print 'wrong input, example useage: \n %s' % useage_str
    if len(sys.argv) == 1:
        print record_query.query(0)
    elif len(sys.argv) == 2:
        print record_query.query(int(sys.argv[1]))
    elif len(sys.argv) == 3:
        print record_query.query(int(sys.argv[1]), int(sys.argv[2]))
