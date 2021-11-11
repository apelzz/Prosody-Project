# -*- coding: utf-8 -*-
"""
Created on Tue Nov  9 13:29:53 2021

@author: zhuzi
"""

import tgt

def merge_tgt(old, new, path):
    transcript = tgt.io.read_textgrid(old, include_empty_intervals=True)
    tobi = tgt.io.read_textgrid(new, include_empty_intervals=True)
    result = tgt.util.merge_textgrids([transcript, tobi])
    tgt.io.write_to_file(result, path)

# if __name__ == '__main__':    
#     result = merge_tgt(r"C:\PyToBI-master\stim\test.TextGrid", r"C:\PyToBI-master\stim\test_result.TextGrid")
#     tgt.io.write_to_file(result, r"C:\PyToBI-master\stim\ahhhh.TextGrid")