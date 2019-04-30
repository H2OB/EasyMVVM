/**
 * Beijing Sankuai Online Technology Co.,Ltd (Meituan)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

#import "RubikModel.h"

@implementation RubikModel

- (instancetype)init {
    if (self = [super init]) {
        
        NSArray *dataArray = @[
                               @{
                                   @"type": @(1),
                                   @"data": @{@"text": @"这里是一个广告位"}
                                   },











                               @{
                                   @"type": @(2),
                                   @"cols": @(5),
                                   @"data": @[
                                           @{@"title": @"打车", @"image": @"cate_1"},
                                           @{@"title": @"KTV", @"image": @"cate_2"},
                                           @{@"title": @"周边游", @"image": @"cate_3"},
                                           @{@"title": @"机票/火车票", @"image": @"cate_4"},
                                           @{@"title": @"跑腿代购", @"image": @"cate_5"},
                                           @{@"title": @"景点/门票", @"image": @"cate_6"},
                                           @{@"title": @"丽人/美发", @"image": @"cate_7"},
                                           @{@"title": @"结婚/摄影", @"image": @"cate_8"},
                                           @{@"title": @"榛果民宿", @"image": @"cate_9"},
                                           @{@"title": @"全部分类", @"image": @"cate_10"},
                                           ]
                                   },
                               @{
                                   @"type": @(3),
                                   @"data": @[
                                           @{   @"name":@"猫头鹰音乐部落1",
                                                @"logo":@"shop_1",
                                                @"desc":@"[4店通用]单人1对1架子鼓精品体验课 送精美礼品",
                                                @"price":@(15.9),
                                                @"tel":@"10086"
                                                },
                                           @{   @"name":@"猫头鹰音乐部落2",
                                                @"logo":@"shop_1",
                                                @"desc":@"[4店通用]单人1对1架子鼓精品体验课 送精美礼品",
                                                @"price":@(15.9),
                                                @"tel":@"10086"
                                                },
                                           @{   @"name":@"猫头鹰音乐部落3",
                                                @"logo":@"shop_1",
                                                @"desc":@"[4店通用]单人1对1架子鼓精品体验课 送精美礼品",
                                                @"price":@(15.9),
                                                @"tel":@"10086"
                                                },
                                           @{   @"name":@"猫头鹰音乐部落4",
                                                @"logo":@"shop_1",
                                                @"desc":@"[4店通用]单人1对1架子鼓精品体验课 送精美礼品",
                                                @"price":@(15.9),
                                                @"tel":@"10086"
                                                },
                                           @{   @"name":@"猫头鹰音乐部落5",
                                                @"logo":@"shop_1",
                                                @"desc":@"[4店通用]单人1对1架子鼓精品体验课 送精美礼品",
                                                @"price":@(15.9),
                                                @"tel":@"10086"
                                                },
                                           @{   @"name":@"猫头鹰音乐部落6",
                                                @"logo":@"shop_1",
                                                @"desc":@"[4店通用]单人1对1架子鼓精品体验课 送精美礼品",
                                                @"price":@(15.9),
                                                @"tel":@"10086"
                                                },
                                           @{   @"name":@"猫头鹰音乐部落7",
                                                @"logo":@"shop_1",
                                                @"desc":@"[4店通用]单人1对1架子鼓精品体验课 送精美礼品",
                                                @"price":@(15.9),
                                                @"tel":@"10086"
                                                },
                                           @{   @"name":@"猫头鹰音乐部落8",
                                                @"logo":@"shop_1",
                                                @"desc":@"[4店通用]单人1对1架子鼓精品体验课 送精美礼品",
                                                @"price":@(15.9),
                                                @"tel":@"10086"
                                                },
                                           @{   @"name":@"猫头鹰音乐部落9",
                                                @"logo":@"shop_1",
                                                @"desc":@"[4店通用]单人1对1架子鼓精品体验课 送精美礼品",
                                                @"price":@(15.9),
                                                @"tel":@"10086"
                                                },
                                           @{   @"name":@"猫头鹰音乐部落10",
                                                @"logo":@"shop_1",
                                                @"desc":@"[4店通用]单人1对1架子鼓精品体验课 送精美礼品",
                                                @"price":@(15.9),
                                                @"tel":@"10086"
                                                },
                                           @{   @"name":@"猫头鹰音乐部落11",
                                                @"logo":@"shop_1",
                                                @"desc":@"[4店通用]单人1对1架子鼓精品体验课 送精美礼品",
                                                @"price":@(15.9),
                                                @"tel":@"10086"
                                                },
                                           @{   @"name":@"猫头鹰音乐部落12",
                                                @"logo":@"shop_1",
                                                @"desc":@"[4店通用]单人1对1架子鼓精品体验课 送精美礼品",
                                                @"price":@(15.9),
                                                @"tel":@"10086"
                                                },
                                           @{   @"name":@"猫头鹰音乐部落13",
                                                @"logo":@"shop_1",
                                                @"desc":@"[4店通用]单人1对1架子鼓精品体验课 送精美礼品",
                                                @"price":@(15.9),
                                                @"tel":@"10086"
                                                },
                                           @{   @"name":@"UCan音乐教室",
                                                @"logo":@"shop_2",
                                                @"desc":@"[对外经贸] 架子鼓 吉他1对1速成班",
                                                @"price":@(2400.0),
                                                @"tel":@"10087"
                                                },
                                           @{   @"name":@"凤凰音赋音乐艺术培训",
                                                @"logo":@"shop_3",
                                                @"desc":@"[三元桥] 架子鼓体验课",
                                                @"price":@(1.0),
                                                @"tel":@"10088"
                                                },
                                           @{   @"name":@"迷笛俱乐部",
                                                @"logo":@"shop_4",
                                                @"desc":@"[远大路] 架子鼓单人体验课",
                                                @"price":@(29.9),
                                                @"tel":@"10089"
                                                },
                                           ]
                                   }
                               ];
        
        _data = [EZRNode new];
        _data.mutablify.value = dataArray;
        
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}


@end
