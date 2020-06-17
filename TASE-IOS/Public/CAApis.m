
//测试
//http://v-api.testcadae.top
//@"ws://websocket.testcadae.top/ws""
//@"ws://websocket.testcadae.top/ws";
NSString * const CAAPI_BASE_URL = @"http://v-api.testcadae.top/mobile_api/v2/";
NSString * const WEBSOCKET_URL = @"ws://websocket.testcadae.top/ws";
NSString * const MATCHER_BASE_URL = @"http://rust.testcadae.top/";

//正式
//http://new-api.cadae.top
//@"ws://websocket.testcadae.top/ws""
//@"ws://websocket.cadae.top/ws""
//NSString * const CAAPI_BASE_URL = @"http://new-api.cadex.top/mobile_api/v2/";
//NSString * const WEBSOCKET_URL = @"ws://websocket.cadex.top/ws";
//ws://websocket.cadex.top/ws




//=================首页接口===================
NSString * const CAAPI_HOMEAPI = @"home/initialize";
NSString * const CAAPI_CHECK_FOR_UPDATES = @"home/check_for_updates";



//加载各个手机号前缀
NSString * const CAAPI_COMMON_CONUNTRY_CODES = @"common/country_codes";

//=================OTC===================
//加载广告列表接口
NSString * const CAAPI_OTC_MY_ADVERTISEMENTS = @"otc/my_advertisements";
//加载所有的订单接口
NSString * const CAAPI_OTC_MY_ORDERS = @"otc/my_orders";
//获取所有的币种
NSString * const CAAPI_OTC_LANDING = @"otc/landing";
//获取法币页面广告列表
NSString * const CAAPI_OTC_GET_ADVERTISEMENTS = @"otc/get_advertisements";
//法币检验是否可以购买的接口
NSString * const CAAPI_OTC_IS_ADVERTISEMENT_CANCELLED = @"otc/is_advertisement_canceled";
//订单详情
NSString * const CAAPI_OTC_SHOW_TRADING = @"otc/show_trading";
//编辑广告
NSString * const CAAPI_OTC_EDIT_ADVERTISEMENT = @"otc/edit_advertisement";
//下单接口
NSString * const CAAPI_OTC_CREATE_TRADING = @"otc/create_trading";
//取消订单
NSString * const CAAPI_OTC_CANCLE_TRADING = @"otc/cancel_trading";
//我已成功付款
NSString * const CAAPI_OTC_MARK_BUYER_HAS_PAID = @"otc/mark_buyer_has_paid";
//延长付款时间接口
NSString * const CAAPI_OTC_MARK_TRADING_OVERTIME = @"otc/mark_trading_overtime";
//放币接口
NSString * const CAAPI_OTC_SELLER_HAS_RELEASED = @"otc/mark_seller_has_released";
//创建广告
NSString * const CAAPI_OTC_CREATE_ADVERTISEMENT = @"otc/create_advertisement";
//编辑广告
NSString * const CAAPI_OTC_UPDATE_ADVERTISEMENT = @"otc/update_advertisement";
//上下架广告
NSString * const CAAPI_OTC_UPDATE_ADVERTISEMENT_IS_CANCLLED_STATUS = @"otc/update_advertisement_is_canceled_status";
//进入到编辑昵称页面:
NSString * const CAAPI_OTC_EDIT_NICK_NAME = @"otc/edit_nick_name";
//更新nick_name:
NSString * const CAAPI_OTC_UPDATE_NICK_NAME = @"otc/update_nick_name";
//申诉接口
NSString * const CAAPI_OTC_CREATE_DISPUTE = @"otc/create_dispute";
//聊天列表接口
NSString * const CAAPI_OTC_MESSAGES = @"otc/messages";


//币币交易 添加到自选
NSString * const CAAPI_CRYPTO_TO_CRYPTO_ADD_TO_FAVAORATES = @"crypto_to_crypto/add_to_favorites";
//币币交易 移除自选
NSString * const CAAPI_CRYPTO_TO_CRYPTO_REMOVE_FROM_FAVAORATES = @"crypto_to_crypto/remove_from_favorites";

//获取交易对 余额 汇率
NSString * const CAAPI_CRYPTO_TO_CRYPTO_MARKET_SCALE = @"crypto_to_crypto/market_scale";
//创建币币交易订单
NSString * const CAAPI_CRYPTO_TO_CRYPTO_CREATE_ORDER = @"/create_order";
//当前委托
NSString * const CAAPI_CRYPTO_TO_CRYPTO_CURRENT_ORDERS = @"crypto_to_crypto/current_orders";
//全部委托
NSString * const CAAPI_CRYPTO_TO_CRYPTO_ORDERS = @"crypto_to_crypto/orders";
//历史记录
NSString * const CAAPI_CRYPTO_TO_CRYPTO_MY_ORDERS = @"crypto_to_crypto/my_trades";
//单独取消
NSString * const CAAPI_CRYPTO_TO_CRYPTO_CANCEL_ORDERS = @"crypto_to_crypto/cancel_order";
//取消全部
NSString * const CAAPI_CRYPTO_TO_CRYPTO_CANCEL_ALL_ORDERS = @"crypto_to_crypto/cancel_all_orders";
//订单详情
NSString * const CAAPI_CRYPTO_TO_CRYPTO_TRADE_DEATAIL = @"crypto_to_crypto/trade_detail";
//判断该交易对是否已经添加到自选区
NSString * const CAAPI_CRYPTO_TO_CRYPTO_IS_ADD_TO_FAVORATES = @"crypto_to_crypto/is_add_to_favorites";
//获取交易对
NSString * const CAAPI_CRYPTO_TO_CRYPTO_GET_MARKETS = @"crypto_to_crypto/get_markets";
//返回用户自选
NSString * const CAAPI_CRYPTO_TO_CRYPTO_SHOW_ALL_FAVOURITE_MARKETS_DETAILS = @"crypto_to_crypto/show_all_favourite_markets_details";




//========================用户=============
//修改密码
NSString * const CAAPI_MEMBERS_UPDATE_PASSWORD = @"members/update_password";
//登录
NSString * const CAAPI_MEMBERS_SIGN_IN = @"members/sign_in";
//退出
NSString * const CAAPI_MEMBERS_SIGN_OUT = @"members/sign_out";
//忘记密码发送手机验证码
NSString * const CAAPI_MEMBERS_FORGOT_PASSWORD_SEND_SMS_CODE = @"members/forgot_password_send_sms_code";
//忘记密码发送邮箱验证码
NSString * const CAAPI_MEMBERS_FORGOT_PASSWORD_SEND_EMAIL_CODE = @"members/forgot_password_send_bind_email_code";
//注册
NSString * const CAAPI_MEMBERS_SIGN_UP = @"members/sign_up";
//忘记密码接口
NSString * const CAAPI_MEMBERS_GORGOT_PASWORD = @"members/forgot_password";
//注册发送邮箱验证码接口
NSString * const CAAPI_MEMBERS_SEND_EMAIL_TOKEN_FOR_SIGN_UP = @"members/send_email_token_for_sign_up";
//注册发送手机验证码接口
NSString * const CAAPI_MEMBERS_SEND_SMS_TOKEN_FOR_SIGN_UP = @"members/send_sms_token_for_sign_up";
//登录发送手机验证码接口
NSString * const CAAPI_MEMBERS_SEND_SMS_TOKEN_TO_MEMBER = @"members/send_sms_token_to_member";
//获取绑定的手机号 或者 邮箱 没有手机号返回邮箱
NSString * const CAAPI_MINE_ENTER_ASSET_PASSWORD = @"mine/enter_update_asset_password";
//获取绑定的手机号
NSString * const CAAPI_MINE_GET_BIND_MOBILE = @"mine/get_bind_mobile";
//重新绑定手机号
NSString * const CAAPI_MINE_BIND_MOBILE = @"mine/bind_mobile";
//编辑绑定的邮箱
NSString * const CAAPI_MINE_EDIT_BIND_EMAIL = @"mine/edit_bind_email";
//绑定邮箱
NSString * const CAAPI_MINE_BIDN_EMAIL = @"mine/bind_email";
//解绑邮箱
NSString * const CAAPI_MINE_UNBIDN_EMAIL = @"mine/unbind_email";
//修改资金密码
NSString * const CAAPI_MINE_UPDATE_ASSET_PASSWORD = @"mine/update_asset_password";
//获取邀请码
NSString * const CAAPI_MINE_INVITATION_CODE = @"mine/invitation_code";
//我的资产
NSString * const CAAPI_MINE_ASSETS = @"mine/assets";
//我的资产 详情
NSString * const CAAPI_MINE_ASSETS_RECORDS = @"mine/assets_records";
//我的资产 详情 assets_record_detail
NSString * const CAAPI_MINE_ASSETS_RECORDS_DETAIL = @"mine/assets_record_detail";
//我的好友
NSString * const CAAPI_MINE_FRIENDS = @"mine/friends";
//个人中心
NSString * const CAAPI_MINE_PERSONAL_CENTER = @"mine/personal_center";
//发送短信验证码
NSString * const CAAPI_MINE_SEND_SMS_VALIDATION_CODE = @"mine/send_sms_validation_code";
//绑定邮箱 发送邮箱验证码接口
NSString * const CAAPI_MINE_SEND_BIND_EMAIL_CODE = @"mine/send_bind_email_code";
//实名认证
NSString * const CAAPI_MINE_UPLOAD_ID_CARD_FILES = @"mine/upload_id_card_files";
//显示收款方式
NSString * const CAAPI_MINE_SHOW_PAYMENT_METHODS_PAGE = @"mine/show_payment_methods_page";
//添加收款方式
NSString * const CAAPI_MINE_UPDATE_PAYMENT_METHODS = @"mine/update_payment_methods";
//支付方式激活
NSString * const CAAPI_MINE_UPDATE_PAYMENT_ACTIVATED_STATUS = @"mine/update_payment_activated_status";
//可以添加的支付方式
NSString * const CAAPI_MINE_NEW_PAYMENT_METHOD = @"mine/new_payment_method";

//资金密码 发送邮箱验证码
NSString * const CAAPI_MINE_UPDATE_ASSET_PASSWORD_SEND_EMAIL_CODE = @"mine/update_asset_password_send_email_code";
//资金密码 发送短信验证码
NSString * const CAAPI_MINE_UPDATE_ASSET_PASSWORD_SEND_MOBILE_CODE = @"mine/update_asset_password_send_mobile_code";
//意见反馈
NSString * const CAAPI_MINE_FEEDBACK = @"mine/feedback";

NSString * const CAAPI_MINE_UPLOAD_ID_CARD_INFORMATION = @"mine/upload_id_card_information";
NSString * const CAAPI_MINE_AFTER_SCAN_FACE = @"mine/after_scan_face";


//==========币种============
//站内转账
NSString * const CAAPI_CURRENCY_INTERNAL_TRANSFER = @"currency/internal_transfer";
//生成充币地址
NSString * const CAAPI_CURRENCY_GRNERATE_DEPOSIT_ADDRESS = @"currency/generate_deposit_address";
//获取币种的充币地址
NSString * const CAAPI_CURRENCY_DEPOSIT_ADDRESS = @"currency/deposit_address";
//站内转账 加载当前币种的转账的信息 余额 等
NSString * const CAAPI_CURRENCY_SHOW_INTERNAL_TRANSFER_PAGE = @"currency/show_internal_transfer_page";
//提币 加载当前币种的转账的信息 余额 等
NSString * const CAAPI_CURRENCY_SHOW_WITHDRAW_PAGE = @"currency/show_withdraw_page";
//币种简介
NSString * const CAAPI_CURRENCY_DETAILS = @"currency/currency_detail";
//发起提币申请
NSString * const CAAPI_CURRENCY_WITHDRAW = @"currency/withdraw";


