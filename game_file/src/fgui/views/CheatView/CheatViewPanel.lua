local gametop = gModuleMgr.getObject("gametop")
local cheatCtrl = SoraDGetCtrl("cheatCtrl")
local publicRead = include("publicRead")
local resDesRead = include("resDesRead")
local capi_replaceSrc_requestNewTrunk = function(url, version)
	cc.ReplaceSrc:GetInstance():EditUpdatePackagePath(version)
	cc.ReplaceSrc:GetInstance():RequestNewTrunk(url)
end
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatViewPanel = class("CheatViewPanel", baseFguiPanel)
function CheatViewPanel:ctor(...)
	CheatViewPanel.super.ctor(self, ...)
	print("CheatViewPanel:ctor", self.viewName)
	self.debug = true
end
function CheatViewPanel:onHide()
	SoraDCloseLoading()
end
function CheatViewPanel:onInit()
	print("=======CheatViewPanel:onInit")
	self.tableItem, _ENV = print, print
	local resCfg = resDesRead.Resinfo
	for id, cfg in pairs(resCfg) do
		table.insert(self.tableItem, id)
	end
	table.sort(self.tableItem)
	_ENV, _UPVALUE18_, _ENV, self.btnIndex = pairs(resCfg)
	pairs(resCfg).btnName = "战斗模拟工具"
	_ENV, pairs(resCfg).func = nil, "fightDemo"
	;(nil).btnName = "清空背包"
	_ENV, (nil).func = nil, "clearBag"
	;(nil).btnName = "断线重连"
	_ENV, (nil).func = table.insert, "disconnect"
	table.insert.btnName = "增加士兵"
	_ENV, table.insert.func = self.tableItem, "addArmy"
	self.tableItem.btnName = "添加装备"
	_ENV, self.tableItem.func = id, "addEquipment"
	id.btnName = "战斗属性模拟测试"
	_ENV, id.func = nil, "battleAttrTest"
	;(nil).btnName = "查询所有活动"
	_ENV, (nil).func = nil, "showAllActivity"
	;(nil).btnName = "显示帧率"
	_ENV, (nil).func = nil, "fps"
	;(nil).btnName = "显示内存"
	_ENV, (nil).func = nil, "mem"
	;(nil).btnName = "清除内更内容"
	_ENV, (nil).func = nil, "cleanUpdateCode"
	;(nil).btnName = "保存默认字体贴图"
	_ENV, (nil).func = nil, "saveDefaultFontTexture"
	;(nil).btnName = "切换白昼"
	_ENV, (nil).func = nil, "dayNight"
	;(nil).btnName = "切换账号"
	_ENV, (nil).func = nil, "changeUser"
	;(nil).btnName = "清空账号缓存"
	_ENV, (nil).func = nil, "cleanUser"
	;(nil).btnName = "低内存评级"
	_ENV, (nil).func = nil, "lowMemory"
	;(nil).btnName = "账号信息"
	_ENV, (nil).func = nil, "userAccountInfo"
	;(nil).btnName = "清除本地数据缓存"
	_ENV, (nil).func = nil, "clearLocalData"
	;(nil).btnName = "旧版作弊"
	_ENV, (nil).func = nil, "oldCheatView"
	;(nil).btnName = "MicEnable"
	_ENV, (nil).func = nil, "MicEnable"
	;(nil).btnName = "MicDisable"
	;(nil).func = "MicDisable"
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[1] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[2] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[3] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[4] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[5] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[6] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[7] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[8] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[9] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[10] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[11] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[12] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[13] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[14] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[15] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[16] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[17] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[18] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[19] = pairs(resCfg)
	_ENV, _UPVALUE12_, table.sort[1], self.tableItem[20] = pairs(resCfg)
	pairs(resCfg).btnName = "清空图片"
	_ENV, pairs(resCfg).func = nil, "cleanPng"
	;(nil).btnName = "LUA内存"
	_ENV, (nil).func = nil, "luaMemory"
	;(nil).btnName = "3D切换"
	_ENV, (nil).func = table.insert, "switch3D"
	table.insert.btnName = "重启lua"
	_ENV, table.insert.func = self.tableItem, "reloadLua"
	self.tableItem.btnName = "释放资源"
	_ENV, self.tableItem.func = id, "releaseSource"
	id.btnName = "开启远程控制台"
	_ENV, id.func = nil, "openConsole"
	;(nil).btnName = "开启远程调试"
	_ENV, (nil).func = nil, "remoteDebug"
	;(nil).btnName = "远程打印日志"
	_ENV, (nil).func = nil, "connect2LogServer"
	;(nil).btnName = "生成ctrl文件"
	_ENV, (nil).func = nil, "createCtrl"
	;(nil).btnName = "生成通用活动代码"
	_ENV, (nil).func = nil, "createActivity"
	;(nil).btnName = "开启消息日志"
	_ENV, (nil).func = nil, "openMsgDump"
	;(nil).btnName = "旧版打印日志"
	;(nil).func = "btnOpenLog"
	_ENV, _UPVALUE8_, table.sort[2], self.tableItem[1] = pairs(resCfg)
	_ENV, _UPVALUE8_, table.sort[2], self.tableItem[2] = pairs(resCfg)
	_ENV, _UPVALUE8_, table.sort[2], self.tableItem[3] = pairs(resCfg)
	_ENV, _UPVALUE8_, table.sort[2], self.tableItem[4] = pairs(resCfg)
	_ENV, _UPVALUE8_, table.sort[2], self.tableItem[5] = pairs(resCfg)
	_ENV, _UPVALUE8_, table.sort[2], self.tableItem[6] = pairs(resCfg)
	_ENV, _UPVALUE8_, table.sort[2], self.tableItem[7] = pairs(resCfg)
	_ENV, _UPVALUE8_, table.sort[2], self.tableItem[8] = pairs(resCfg)
	_ENV, _UPVALUE8_, table.sort[2], self.tableItem[9] = pairs(resCfg)
	_ENV, _UPVALUE8_, table.sort[2], self.tableItem[10] = pairs(resCfg)
	_ENV, _UPVALUE8_, table.sort[2], self.tableItem[11] = pairs(resCfg)
	_ENV, _UPVALUE8_, table.sort[2], self.tableItem[12] = pairs(resCfg)
	pairs(resCfg).btnName = "添加假行军队列"
	_ENV, pairs(resCfg).func = nil, "addMoveLine"
	;(nil).btnName = "VIP时间加减"
	_ENV, (nil).func = nil, "changeVipTime"
	;(nil).btnName = "领主经验等级"
	_ENV, (nil).func = table.insert, "changeLordLVEXP"
	table.insert.btnName = "魔物地宫精英时间"
	_ENV, table.insert.func = self.tableItem, "changeEvilEliteTime"
	self.tableItem.btnName = "总动员成员需求"
	_ENV, self.tableItem.func = id, "changeMobilizationMember"
	id.btnName = "总动员刷新时间"
	_ENV, id.func = nil, "changeMobilizationTime"
	;(nil).btnName = "竞技场时间设置"
	_ENV, (nil).func = nil, "setArenaTime"
	;(nil).btnName = "执行脚本"
	;(nil).func = "runScript"
	_ENV, _UPVALUE25_, table.sort[3], self.tableItem[1] = pairs(resCfg)
	_ENV, _UPVALUE25_, table.sort[3], self.tableItem[2] = pairs(resCfg)
	_ENV, _UPVALUE25_, table.sort[3], self.tableItem[3] = pairs(resCfg)
	_ENV, _UPVALUE25_, table.sort[3], self.tableItem[4] = pairs(resCfg)
	_ENV, _UPVALUE25_, table.sort[3], self.tableItem[5] = pairs(resCfg)
	_ENV, _UPVALUE25_, table.sort[3], self.tableItem[6] = pairs(resCfg)
	_ENV, _UPVALUE25_, table.sort[3], self.tableItem[7] = pairs(resCfg)
	_ENV, _UPVALUE25_, table.sort[3], self.tableItem[8] = pairs(resCfg)
	pairs(resCfg).btnName = "庄园内城入口"
	_ENV, pairs(resCfg).func = nil, "manorCityEnter"
	;(nil).btnName = "庄园沙盘入口"
	_ENV, (nil).func = nil, "manorWarEnter"
	;(nil).btnName = "重置庄园"
	_ENV, (nil).func = table.insert, "manorReset"
	table.insert.btnName = "解锁庄园"
	_ENV, table.insert.func = self.tableItem, "manorUnlock"
	self.tableItem.btnName = "烈焰沙场新手引导"
	_ENV, self.tableItem.func = id, "roaringFlameWarGuide"
	id.btnName = "烈焰沙场建筑列表"
	_ENV, id.func = nil, "roaringFlameWarBuild"
	;(nil).btnName = "烈焰沙场连线地图"
	_ENV, (nil).func = nil, "roaringFlameWarMap"
	;(nil).btnName = "修改最强领主状态"
	_ENV, (nil).func = nil, "changeLordActivityState"
	;(nil).btnName = "改变总动员状态"
	_ENV, (nil).func = nil, "changeMobilizationState"
	;(nil).btnName = "开启总动员"
	_ENV, (nil).func = nil, "openMobilization"
	;(nil).btnName = "地图坐标"
	_ENV, (nil).func = nil, "toggleMapDebug"
	;(nil).btnName = "主城水开关"
	_ENV, (nil).func = nil, "waterSwitch"
	;(nil).btnName = "地图水特效切换"
	_ENV, (nil).func = nil, "toggleWorldWater"
	;(nil).btnName = "录屏测试"
	_ENV, (nil).func = nil, "replayTest"
	;(nil).btnName = "隐藏主UI"
	_ENV, (nil).func = nil, "hideMainUI"
	;(nil).btnName = "隐藏主城"
	_ENV, (nil).func = nil, "hideMainCity"
	;(nil).btnName = "隐藏作弊神秘"
	_ENV, (nil).func = nil, "hideCheat"
	;(nil).btnName = "隐藏地图"
	_ENV, (nil).func = nil, "hideWorldMap"
	;(nil).btnName = "fabric隐私"
	_ENV, (nil).func = nil, "fabric"
	;(nil).btnName = "富文本测试"
	_ENV, (nil).func = nil, "richTextTest"
	;(nil).btnName = "聊天测试"
	_ENV, (nil).func = nil, "chatTest"
	;(nil).btnName = "切换聊天调试"
	_ENV, (nil).func = nil, "toggleChatDebug"
	;(nil).btnName = "重置今日弹窗时间"
	_ENV, (nil).func = nil, "resetPopTime"
	;(nil).btnName = "光明之战开关"
	_ENV, (nil).func = nil, "radianceWar"
	;(nil).btnName = "清空宠物喂养经验"
	_ENV, (nil).func = nil, "cleanPetDailyFeedEXP"
	;(nil).btnName = "LOD配置"
	_ENV, (nil).func = nil, "scaleConfig"
	;(nil).btnName = "Test"
	_ENV, (nil).func = nil, "btnTest"
	;(nil).btnName = "内外城切换动画开关"
	_ENV, (nil).func = nil, "switchMode"
	;(nil).btnName = "屏蔽星云全明星战场判断"
	_ENV, (nil).func = nil, "nebulaAllStarCheat"
	;(nil).btnName = "拾取队列测试"
	_ENV, (nil).func = nil, "nebulaAllStarSpoilQueue"
	;(nil).btnName = "士兵试炼"
	_ENV, (nil).func = nil, "heroTrial"
	;(nil).btnName = "应用下载"
	_ENV, (nil).func = nil, "gotoDownURl"
	;(nil).btnName = "登录公告测试"
	;(nil).func = "loginNoticeTest"
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[1] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[2] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[3] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[4] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[5] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[6] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[7] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[8] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[9] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[10] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[11] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[12] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[13] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[14] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[15] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[16] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[17] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[18] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[19] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[20] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[21] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[22] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[23] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[24] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[25] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[26] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[27] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[28] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[29] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[30] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[31] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[32] = pairs(resCfg)
	_ENV, _UPVALUE5_, table.sort[4], self.tableItem[33] = pairs(resCfg)
	pairs(resCfg).btnName = "历史最高战力"
	_ENV, pairs(resCfg).func = nil, "historyMaxFc"
	;(nil).btnName = "礼包充值样式"
	_ENV, (nil).func = nil, "lookRechargeStyle"
	;(nil).btnName = "图片状态"
	_ENV, (nil).func = table.insert, "pngStatus"
	table.insert.btnName = "英雄预览"
	_ENV, table.insert.func = self.tableItem, "heroReview"
	self.tableItem.btnName = "纹理信息"
	self.tableItem.func = "textureInfo"
	_ENV, _UPVALUE13_, table.sort[5], self.tableItem[1] = pairs(resCfg)
	_ENV, _UPVALUE13_, table.sort[5], self.tableItem[2] = pairs(resCfg)
	_ENV, _UPVALUE13_, table.sort[5], self.tableItem[3] = pairs(resCfg)
	_ENV, _UPVALUE13_, table.sort[5], self.tableItem[4] = pairs(resCfg)
	_ENV, _UPVALUE13_, table.sort[5], self.tableItem[5] = pairs(resCfg)
	pairs(resCfg).btnName = "连连看"
	_ENV, pairs(resCfg).func = nil, "linkLinkGame"
	;(nil).btnName = "路见不平"
	_ENV, (nil).func = nil, "roadRoughGame"
	;(nil).btnName = "射击游戏"
	_ENV, (nil).func = table.insert, "shootGame"
	table.insert.btnName = "拼图游戏"
	_ENV, table.insert.func = self.tableItem, "puzzleGame"
	self.tableItem.btnName = "潜行射击"
	_ENV, self.tableItem.func = id, "sneakSnipeGame"
	id.btnName = "潜行射击2"
	_ENV, id.func = nil, "sneakSnipeGame2"
	;(nil).btnName = "潜行射击3"
	_ENV, (nil).func = nil, "sneakSnipeGame3"
	;(nil).btnName = "子弹弹射"
	_ENV, (nil).func = nil, "bulletGame"
	;(nil).btnName = "新三消测试"
	_ENV, (nil).func = nil, "newEliminateGame"
	;(nil).btnName = "克朗棋"
	_ENV, (nil).func = nil, "open9001676Game"
	;(nil).btnName = "消消乐"
	_ENV, (nil).func = nil, "sheepSheepGame"
	;(nil).btnName = "510K"
	_ENV, (nil).func = nil, "fiveTenKGame"
	;(nil).btnName = "数独游戏"
	;(nil).func = "numberGame"
	self.tableBtn, table.sort[6], self.tableItem[1] = table.sort, self.tableItem, pairs(resCfg)
	self.tableBtn, table.sort[6], self.tableItem[2] = table.sort, self.tableItem
	self.tableBtn, table.sort[6], self.tableItem[3] = table.sort, self.tableItem
	self.tableBtn, table.sort[6], self.tableItem[4] = table.sort, self.tableItem, table.insert
	self.tableBtn, table.sort[6], self.tableItem[5] = table.sort, self.tableItem, self.tableItem
	self.tableBtn, table.sort[6], self.tableItem[6] = table.sort, self.tableItem, id
	self.tableBtn, table.sort[6], self.tableItem[7] = table.sort, self.tableItem
	self.tableBtn, table.sort[6], self.tableItem[8] = table.sort, self.tableItem
	self.tableBtn, table.sort[6], self.tableItem[9] = table.sort, self.tableItem
	self.tableBtn, table.sort[6], self.tableItem[10] = table.sort, self.tableItem
	self.tableBtn, table.sort[6], self.tableItem[11] = table.sort, self.tableItem
	self.tableBtn, table.sort[6], self.tableItem[12] = table.sort, self.tableItem
	self.tableBtn, table.sort[6], self.tableItem[13] = table.sort, self.tableItem
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local pyramidWarCtrl = SoraDGetCtrl("pyramidWarCtrl")
	local allianceId = allianceMgr:getOwnAid()
	local teamId = allianceMgr:getOwnTeamID()
	local kingdomID = gametop.playertop_:getMapID()
	local legionId = pyramidWarCtrl:getOwnLegion() and pyramidWarCtrl:getOwnLegion().legionId or 0
	local titleStr = "真实UID:" .. gametop.playertop_:getPlayerID() .. ",aid:" .. tostring(allianceId) .. ",tid:" .. tostring(teamId) .. ",kid:" .. tostring(kingdomID) .. ",gid:" .. tostring(legionId)
	local nebulaWarUtil = include("nebulaWarUtil")
	local group = nebulaWarUtil.getRegionGroup()
	titleStr = titleStr .. ",group:" .. tostring(group)
	self.fields.Com_title:initData(titleStr, handler(self, self.onClickClose))
	self.fields.Com_title:setTitleWidthHeight(500, 60)
	self.input_num = self.fields.input_num:getChild("input")
	self.input_num:setText(10000000)
	self.fields.Button_add:setString("我要增加")
	self.fields.Button_add:addClickListener(handler(self, self.btnAddClick))
	self.fields.icon:addClickListener(handler(self, self.btnSourceClick))
	self.input_id = self.fields.input_id:getChild("input")
	self.input_id:setPromptHolder("战场id/房间id")
	self.fields.Button_enter:setString("进战场")
	self.fields.Button_enter:addClickListener(handler(self, self.btnEnterClick))
	self.fields.Image_enter:addClickListener(handler(self, self.btnEnterClick2))
	self.fields.Button_cheat:setString("我要作弊")
	self.fields.Button_cheat:addClickListener(handler(self, self.btnCheatClick))
	self.input_cmd = self.fields.input_cmd:getChild("input")
	self.input_cmd:setPromptHolder("指令(qkbb)")
	self.input_param = self.fields.input_param:getChild("input")
	self.input_param:setPromptHolder("参数(10,20)")
	self.fields.Button_cmd:setString("发送指令")
	self.fields.Button_cmd:addClickListener(handler(self, self.btnCmdClick))
	self.input_itemID = self.fields.input_itemID:getChild("input")
	self.input_itemID:setPromptHolder("道具ID")
	self.input_itemCount = self.fields.input_itemCount:getChild("input")
	self.input_itemCount:setPromptHolder("道具数量")
	self.fields.Button_itemAdd:setString("添加道具")
	self.fields.Button_itemAdd:addClickListener(handler(self, self.btnItemAddClick))
	self.curQAIndex = 1
	local _ENV, items = "curQAIndex", "curQAIndex"
	local _ENV, values = self.fields.Button_itemAdd, self.fields.Button_itemAdd
	for k, v in ipairs(gSvrlist.planList) do
		table.insert(items, v.name)
		table.insert(values, k)
	end
	_ENV = "ComboBox_QA"
	;("ComboBox_QA").items = items
	;("ComboBox_QA").values = values
	;("ComboBox_QA").changedCallback = handler(self, self.onComboBoxQAClick)
	self:setComboBox(self.fields.ComboBox_QA, "ComboBox_QA")
	local dropdown = self.fields.ComboBox_QA:getDropdown()
	self.comboBoxQAList = dropdown:getChildByName("list")
	self.fields.ComboBox_QA:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxQAList:setSelectedIndex(self.curQAIndex - 1)
	end)
	self.fields.ComboBox_QA:fixChildrenPos()
	self.fields.Button_updateTable:setString("更新表")
	self.fields.Button_updateTable:addClickListener(handler(self, self.btnUpdateTable))
	self.curCXIndex = 1
	local _ENV, cxitems = "curCXIndex", "curCXIndex"
	local _ENV, cxvalues = 1, 1
	for k, v in ipairs(gSvrlist.developerList) do
		table.insert(cxitems, v.name)
		table.insert(cxvalues, k)
	end
	_ENV = "ComboBox_CX"
	;("ComboBox_CX").items = cxitems
	;("ComboBox_CX").values = cxvalues
	;("ComboBox_CX").changedCallback = handler(self, self.onComboBoxCXClick)
	self:setComboBox(self.fields.ComboBox_CX, "ComboBox_CX")
	local dropdown = self.fields.ComboBox_CX:getDropdown()
	self.comboBoxCXList = dropdown:getChildByName("list")
	self.fields.ComboBox_CX:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxCXList:setSelectedIndex(self.curCXIndex - 1)
	end)
	self.fields.ComboBox_CX:fixChildrenPos()
	self.fields.Button_updateCode:setString("更新代码")
	self.fields.Button_updateCode:addClickListener(handler(self, self.btnUpdateCode))
	self.fields.List:setItemRenderer(handler(self, self.onBtnRenderer))
end
function CheatViewPanel:onBtnRenderer(index, obj)
	obj:setString(self.tableBtn[self.btnIndex][index + 1].btnName)
	obj.handle = handler(self, self[self.tableBtn[self.btnIndex][index + 1].func])
	if not obj.isInit then
		obj:addClickListener(function()
			obj.handle()
		end)
		obj.isInit = true
	end
end
function CheatViewPanel:onShow()
	print("=======CheatViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.curItemIndex = 1
	local _ENV, items = self.fields.Com_bg.setGradientColor, self.fields.Com_bg.setGradientColor
	local _ENV, values = self.fields.Com_bg, self.fields.Com_bg
	for k, v in ipairs(self.tableItem) do
		local nameTag = publicRead.getName(v)
		if nameTag == "???" then
			nameTag = v
		end
		table.insert(items, nameTag)
		table.insert(values, k)
	end
	_ENV = nil
	;(nil).items = items
	;(nil).values = values
	;(nil).changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.ComboBox, nil)
	local dropdown = self.fields.ComboBox:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(self.curItemIndex - 1)
	end)
	self.fields.icon:setSpriteFrame(publicRead.getIcon(self.tableItem[self.curItemIndex]))
	self.fields.ComboBox:fixChildrenPos()
	_ENV = publicRead.getIcon(self.tableItem[self.curItemIndex])
	_ENV, _ENV, publicRead.getIcon(self.tableItem[self.curItemIndex]).defaultClick = publicRead.getIcon(self.tableItem[self.curItemIndex])
	_ENV, self.btnIndex[1], publicRead.getIcon(self.tableItem[self.curItemIndex]).title = publicRead.getIcon(self.tableItem[self.curItemIndex])
	_ENV, self.btnIndex[2], publicRead.getIcon(self.tableItem[self.curItemIndex]).title = publicRead.getIcon(self.tableItem[self.curItemIndex])
	_ENV, self.btnIndex[3], publicRead.getIcon(self.tableItem[self.curItemIndex]).title = publicRead.getIcon(self.tableItem[self.curItemIndex])
	_ENV, self.btnIndex[4], publicRead.getIcon(self.tableItem[self.curItemIndex]).title = publicRead.getIcon(self.tableItem[self.curItemIndex])
	_ENV, self.btnIndex[5], publicRead.getIcon(self.tableItem[self.curItemIndex]).title = publicRead.getIcon(self.tableItem[self.curItemIndex])
	publicRead.getIcon(self.tableItem[self.curItemIndex]).tabsetArray, self.btnIndex[6], publicRead.getIcon(self.tableItem[self.curItemIndex]).title = self.btnIndex, publicRead.getIcon(self.tableItem[self.curItemIndex])
	publicRead.getIcon(self.tableItem[self.curItemIndex]).callback = handler(self, self.onTabClick)
	self.fields.com_Tab:initView(publicRead.getIcon(self.tableItem[self.curItemIndex]))
end
function CheatViewPanel:onTabClick(tag)
	self.btnIndex = tag
	self.fields.List:setNumItems(#self.tableBtn[self.btnIndex])
end
function CheatViewPanel:onComboBoxClick()
	SoraDPlaySound()
	self.curItemIndex = tonumber(self.fields.ComboBox:getValue())
	self.fields.icon:setSpriteFrame(publicRead.getIcon(self.tableItem[self.curItemIndex]))
end
function CheatViewPanel:onComboBoxQAClick()
	SoraDPlaySound()
	self.curQAIndex = tonumber(self.fields.ComboBox_QA:getValue())
end
function CheatViewPanel:onComboBoxCXClick()
	SoraDPlaySound()
	self.curCXIndex = tonumber(self.fields.ComboBox_CX:getValue())
end
function CheatViewPanel:cheatSuccess()
end
function CheatViewPanel:btnAddClick()
	SoraDPlaySound()
	local num = tonumber(self.input_num:getText())
	if num then
		_ENV, cheatCtrl = self.input_num:getText()
		self.input_num:getText().id = self.tableItem[self.curItemIndex]
		self.input_num:getText().count = num
		self.input_num:getText()[1] = self.input_num:getText()
		cheatCtrl:reqAddGameItem(self.input_num:getText())
	else
		SoraDShowMsgTip("数量不能为空，且为数字")
	end
end
function CheatViewPanel:btnSourceClick()
	_ENV = nil
	;(nil).style = 4
	uiManager:show("CheatItemWindow", nil)
end
function CheatViewPanel:btnEnterClick()
	SoraDPlaySound()
	local kid = tonumber(self.input_id:getText())
	if kid == nil or kid <= 0 then
		self:btnEnterClick2()
		return
	end
	local max = worldMapDefine.getMaxCoordinateByKid(kid)
	SoraDGotoWorldMapPoint(cc.p(max * 0.5, max * 0.5), false, kid, nil, nil, true)
	self:close()
end
function CheatViewPanel:btnEnterClick2(...)
	uiManager:show("CheatKingdomID")
end
function CheatViewPanel:btnCheatClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).style = 1
	uiManager:show("CheatItemWindow", nil)
end
function CheatViewPanel:btnCmdClick()
	SoraDPlaySound()
	local command = self.input_cmd:getText()
	local param = self.input_param:getText()
	print(command, "command=====")
	dump(param, "param=====")
	local local_fun = self[string.format("local_%s", command)]
	if local_fun then
		local_fun(self, param)
		return
	end
	local extraTab = string.split(command, ",")
	if extraTab[1] and extraTab[2] then
		local data = json.decode(param)
		dump(data, "data=========")
		local serverproxy = gModuleMgr.getObject("serverproxy")
		serverproxy:Request(extraTab[1], extraTab[2], data)
	else
		_ENV = serverproxy
		serverproxy.command = command
		serverproxy.param = param
		cheatCtrl:reqCheat(nil, serverproxy)
	end
end
function CheatViewPanel:btnItemAddClick()
	SoraDPlaySound()
	local itemID = tonumber(self.input_itemID:getText())
	local itemCount = tonumber(self.input_itemCount:getText())
	print("itemID,itemCount=====", itemID, itemCount)
	if itemID and itemCount then
		local _ENV, data = print, print
		_ENV = itemCount
		itemCount.id = itemID
		itemCount.count = itemCount
		table.insert(data, itemCount)
		cheatCtrl:reqAddGameItem(data)
	end
end
function CheatViewPanel:btnUpdateTable()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("测试完记得把persistentDataPath下Sultan/updateTest文件夹删掉")
	;(nil).confirmFunc = function()
		local name = gSvrlist.planList[self.curQAIndex].name
		local stringUrl = string.urlencode(name)
		local url = string.format("http://10.0.3.62:9081/dataUpdate?%s", stringUrl)
		capi_replaceSrc_requestNewTrunk(url, gReplaceType.version)
	end
	uiManager:show("MessageBox", nil)
end
function CheatViewPanel:btnUpdateCode()
	SoraDPlaySound()
	local name = "更新代码测试"
	local ip = gSvrlist.developerList[self.curCXIndex].ip
	local stringUrl = string.urlencode(name)
	local url = string.format("http://%s/dataUpdate?%s", ip, stringUrl)
	capi_replaceSrc_requestNewTrunk(url, gReplaceType.version)
end
function CheatViewPanel:local_jcjdwz(param)
	self:close()
	local worldMapView = SoraDCurrentSceneShowView("worldMapView")
	if not worldMapView then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINSCEN_ONSHOW"
		;(nil).viewType = VIEW_TYPE_MAP
		SoraDSendMessage(nil)
		return
	end
	local ASB = require_data("alliance_stronghold_build", true).data
	if param ~= "" then
		local data = ASB[tonumber(param)]
		if data then
			_ENV = nil
			;(nil).toTilePos = cc.p(data.x, data.y)
			;(nil).isSelected = true
			;(nil).needAction = false
			;(nil).toScale = 0.7501
			worldMapView:gotoTilePointNew(nil, nil)
			return
		end
	end
	local _ENV, ret = data, ASB[tonumber(param)]
	for k, __ in pairs(ASB) do
		table.insert(ret, k)
	end
	table.sort(ret)
	local ASB_config = ret
	local ASB_index = 0
	local delayTime = param and tonumber(param) or 3
	if 100 < delayTime then
		delayTime = 3
	end
	_UPVALUE1_ = k
	k[1] = cca.callFunc(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage(nil)
		local data = ASB[ASB_config[ASB_index]]
		_ENV = nil
		;(nil).toTilePos = cc.p(data.x, data.y)
		;(nil).isSelected = true
		;(nil).needAction = false
		;(nil).toScale = 0.6501
		worldMapView:gotoTilePointNew(nil, nil)
		SoraDShowMsgTip(string.format("%d/%d", ASB_index, #ASB_config))
		if ASB_index > #ASB_config then
			worldMapView:stopAllActions()
		end
	end)
	k[2] = cca.delay(delayTime)
	k[3] = cca.delay(delayTime)
	worldMapView:runAction(cca.repeatForever(cca.seq(k)))
end
function CheatViewPanel:local_djhd(param)
	if param and tonumber(param) > 0 then
		clientEventMgr.singleClickEvent(tonumber(param))
	end
end
function CheatViewPanel:local_kqqmxzc(param)
	_ENV = nil
	;(nil).id = 9001574
	;(nil).allkingdoms = 0
	;(nil).preparetime = 0
	;(nil).activetime = serviceFunctions.systemTime() + 5
	;(nil).settletime = 0
	;(nil).finishtime = 0
	_UPVALUE2_, (nil).kingdoms, _ENV, (nil).allKingdomActive = serviceFunctions.systemTime() + 5, serviceFunctions.systemTime() + 5, serviceFunctions.systemTime() + 5, 0
	;(nil).regions, (serviceFunctions.systemTime() + 5)[1] = serviceFunctions.systemTime() + 5, 1
	;(nil).regions, (serviceFunctions.systemTime() + 5)[2] = serviceFunctions.systemTime() + 5, 2
	local data
	if param and param ~= "" and 0 < tonumber(param) and tonumber(param) < 100 then
		data.regions, _ENV = tonumber(param), tonumber(param)
		for i = 1, tonumber(param) do
			table.insert(data.regions, i)
		end
	end
	local param = "212/" .. json.encode(data)
	_ENV = table.insert
	table.insert.command = "curl"
	table.insert.param = param
	cheatCtrl:reqCheat(nil, table.insert)
end
function CheatViewPanel:local_fsgzdm(param)
	local count, barrageType
	if param and param ~= "" then
		local tab = SoraDStringsSplit(param, ",")
		barrageType = tonumber(tab[1])
		count = tonumber(tab[2])
	end
	local nebulaAllStarUtil = include("nebulaAllStarUtil")
	_ENV = tab[2]
	tab[2].barrageType = barrageType
	tab[2].count = count
	nebulaAllStarUtil.sendTestBarrage(tab[2])
end
function CheatViewPanel:local_kqjdhd(param)
	if not param or param == "" then
		return
	end
	local tab = SoraDStringsSplit(param, ",")
	if tonumber(tab[2]) > 1600000000 then
		_ENV = nil
		;(nil).command = "kqjdhd"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local activityID = tonumber(tab[1])
	local begintime = serviceFunctions.systemTime() + 10
	local lastTime1 = tonumber(tab[2]) * 3600
	local lastTime2 = tonumber(tab[3]) * 3600
	local stagetimes = begintime + lastTime1
	local endtime = stagetimes + lastTime2
	if tab[4] then
		local classtype = tonumber(tab[4])
		local _param = string.format("%d,%d,%d,%d,%d", activityID, begintime, endtime, classtype, stagetimes)
		_ENV = endtime
		endtime.command = "kqjdhd2"
		endtime.param = _param
		cheatCtrl:reqCheat(nil, endtime)
	else
		local _param = string.format("%d,%d,%d,%d", activityID, begintime, endtime, stagetimes)
		_ENV = endtime
		endtime.command = "kqjdhd"
		endtime.param = _param
		cheatCtrl:reqCheat(nil, endtime)
	end
end
function CheatViewPanel:local_gmlyzz(param)
	if not param or param == "" then
		return
	end
	local tab = SoraDStringsSplit(param, ",")
	if #tab < 2 then
		return
	end
	if #tab == 2 then
		_ENV = nil
		;(nil).command = "gmlyzz"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
		return
	end
	local pos = cc.p(tonumber(tab[2]), tonumber(tab[3]))
	local roaringFlameWarRead = include("roaringFlameWarRead")
	for __, cfg in ipairs(roaringFlameWarRead.get_flames_dunes_city()) do
		local buildPos = roaringFlameWarRead.getBuildCoord(cfg.id)
		if buildPos.x == pos.x and buildPos.y == pos.y then
			local _param = string.format("%s,%d", tab[1], cfg.id)
			_ENV = roaringFlameWarRead.get_flames_dunes_city()
			roaringFlameWarRead.get_flames_dunes_city().command = "gmlyzz"
			roaringFlameWarRead.get_flames_dunes_city().param = _param
			cheatCtrl:reqCheat(nil, roaringFlameWarRead.get_flames_dunes_city())
			return
		end
	end
end
function CheatViewPanel:local_sjxg(param)
	local time = tonumber(param)
	if time then
		local timeStr = os.date("!%Y-%m-%d,%H:%M:%S", serviceFunctions.systemTime() + time)
		_ENV = nil
		;(nil).command = "sjxg"
		;(nil).param = timeStr
		cheatCtrl:reqCheat(nil, nil)
	else
		_ENV = nil
		;(nil).command = "sjxg"
		;(nil).param = param
		cheatCtrl:reqCheat(nil, nil)
	end
end
function CheatViewPanel:local_jszy(param)
	cheatCtrl = nil
	;(nil).command = "jszy"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
	self:disconnect()
end
function CheatViewPanel:local_czzy(param)
	local manorCityUtil = include("manorCityUtil")
	manorCityUtil.resetGardenNewConfig()
	_ENV = nil
	;(nil).command = "czzy"
	;(nil).param = param
	cheatCtrl:reqCheat(nil, nil)
	self:disconnect()
end
function CheatViewPanel:fightDemo()
	uiManager:show("CheatFightDemo")
end
function CheatViewPanel:clearBag()
	cheatCtrl:reqCheat("CLEAR_BACKPACK")
end
function CheatViewPanel:cleanUpdateCode()
	SoraDClearUpdatePacker()
end
function CheatViewPanel:saveDefaultFontTexture()
	CS.FairyGUI.FontManager.SaveDynamicFontTexture("NotoNaskhArabicDiy-Regular")
end
function CheatViewPanel:disconnect()
	userSDKManager_sdkOpenCallBack()
end
function CheatViewPanel:fps()
	if cc.Director:getInstance():isDisplayStats() then
		cc.Director:getInstance():setDisplayStats(false)
	else
		cc.Director:getInstance():setDisplayStats(true)
	end
end
function CheatViewPanel:mem()
	if cc.Director:getInstance():isDisplayStats(true) then
		cc.Director:getInstance():setDisplayMemStats(false)
	else
		cc.Director:getInstance():setDisplayMemStats(true)
	end
end
function CheatViewPanel:historyMaxFc()
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local histMaxFc = lordInfoCtrl:getHistMaxFc()
	local histMaxArmyFc = lordInfoCtrl:getHistMaxArmyFc()
	local str = "历史最高战力：" .. string.formatnumberthousands(histMaxFc) .. [[


]]
	str = str .. "士兵历史最高战力：" .. string.formatnumberthousands(histMaxArmyFc)
	_ENV = histMaxArmyFc
	histMaxArmyFc.content = str
	uiManager:show("MessageBox", histMaxArmyFc)
end
function CheatViewPanel:showAllActivity()
	uiManager:show("CheatActivity")
	self:close()
end
function CheatViewPanel:lookRechargeStyle()
	local panel = SoraDCreatePanel("commonTestView")
	panel:initRechargeTypeData()
	panel:show()
end
function CheatViewPanel:addMoveLine()
	_ENV = nil
	;(nil).prompt = "玩家id,数量"
	;(nil).btnTitle = "添加队列"
	;(nil).handle = function(inputText)
		if not string.split(inputText, ",") then
			local _ENV, param = string.split(inputText, ","), string.split(inputText, ",")
		end
		local uid = tonumber(param[1]) or SoraDGetPlayerID()
		local count = tonumber(param[2]) or 100
		local myCityTilePoint = SoraDGetCtrl("cityCtrl"):getCurCityPos()
		_UPVALUE19_ = SoraDGetCtrl("cityCtrl")
		SoraDGetCtrl("cityCtrl")[1] = 9002301
		SoraDGetCtrl("cityCtrl")[2] = 9002315
		SoraDGetCtrl("cityCtrl")[3] = 9002303
		SoraDGetCtrl("cityCtrl")[4] = 9002305
		SoraDGetCtrl("cityCtrl")[5] = 9002307
		SoraDGetCtrl("cityCtrl")[6] = 9002311
		SoraDGetCtrl("cityCtrl")[7] = 9002302
		SoraDGetCtrl("cityCtrl")[8] = 9002925
		SoraDGetCtrl("cityCtrl")[9] = 9002317
		SoraDGetCtrl("cityCtrl")[10] = 9002320
		SoraDGetCtrl("cityCtrl")[11] = 9002324
		SoraDGetCtrl("cityCtrl")[12] = 9002329
		SoraDGetCtrl("cityCtrl")[13] = 9002335
		SoraDGetCtrl("cityCtrl")[14] = 9002339
		SoraDGetCtrl("cityCtrl")[15] = 9002343
		SoraDGetCtrl("cityCtrl")[16] = 9002348
		SoraDGetCtrl("cityCtrl")[17] = 9002356
		SoraDGetCtrl("cityCtrl")[18] = 9002359
		SoraDGetCtrl("cityCtrl")[19] = 9002363
		SoraDGetCtrl("cityCtrl")[20] = 9002371
		SoraDGetCtrl("cityCtrl")[21] = 9002374
		local SoraDGetCtrl("cityCtrl")[22], effectIds = 9002309, SoraDGetCtrl("cityCtrl")
		for i = 1, count do
			local randomX = math.random(1, 1199)
			local randomY = math.random(1, 1199)
			local randomID1 = math.random(1, 10000)
			local randomID2 = math.random(1, 10000)
			local effectIdx = math.random(1, #effectIds)
			local id1 = string.format("%d-%d-4-0-%d", myCityTilePoint.x + 1, myCityTilePoint.y + 1, uid)
			local id2 = string.format("%d-%d-6-0-3022%d%d", randomX + 1, randomY + 1, randomID1, randomID2)
			local startTime = serviceFunctions.systemTime()
			_ENV = randomX + 1
			;(randomX + 1).alliance = 2961
			;(randomX + 1).captureHeroAsAttacker = false
			;(randomX + 1).createTime = startTime
			_ENV, _UPVALUE3_, randomID2.armsInfo, _ENV, _ENV, _UPVALUE1_, _ENV, (randomX + 1).effectId = 9002359, 9002356, 9002356, 9002356, randomID2, randomID1, effectIds[effectIdx], effectIds[effectIdx]
			;(9002359).id = 6010009412
			_ENV, (9002359).num = 9002363, 6186
			;(9002363).id = 6010009512
			_ENV, (9002363).num = 9002371, 87000
			;(9002371).id = 6010009612
			;(9002371).num = 289054
			_ENV, _UPVALUE5_, randomID2.divineBeastInfo, _ENV, randomID2.armyList, (9002356)[1] = 9002359, 9002356, 9002356, 9002356, 9002356, 9002359
			_ENV, _UPVALUE5_, randomID2.divineBeastInfo, _ENV, randomID2.armyList, (9002356)[2] = 9002359, 9002356, 9002356, 9002356, 9002356, 9002363
			_ENV, _UPVALUE5_, randomID2.divineBeastInfo, _ENV, randomID2.armyList, (9002356)[3] = 9002359, 9002356, 9002356, 9002356, 9002356, 9002371
			;(9002359).dressID = 173401
			;(9002359).exp = 0
			;(9002359).heroID = 1734
			;(9002359).isAwake = false
			;(9002359).level = 1
			_ENV, (9002359).quality = 9002363, 1
			;(9002363).dressID = 174701
			;(9002363).exp = 0
			;(9002363).heroID = 1747
			;(9002363).isAwake = false
			;(9002363).level = 1
			_ENV, (9002363).quality = 9002371, 1
			;(9002371).dressID = 173601
			;(9002371).exp = 0
			;(9002371).heroID = 1736
			;(9002371).isAwake = false
			;(9002371).level = 1
			_ENV, (9002371).quality = 9002374, 1
			;(9002374).dressID = 173701
			;(9002374).exp = 0
			;(9002374).heroID = 1737
			;(9002374).isAwake = false
			;(9002374).level = 1
			_ENV, (9002374).quality = 9002309, 1
			;(9002309).dressID = 173801
			;(9002309).exp = 0
			;(9002309).heroID = 1738
			;(9002309).isAwake = false
			;(9002309).level = 1
			;(9002309).quality = 1
			randomID2.heroInfo, (9002356)[1] = 9002356, 9002359
			randomID2.heroInfo, (9002356)[2] = 9002356, 9002363
			randomID2.heroInfo, (9002356)[3] = 9002356, 9002371
			randomID2.heroInfo, (9002356)[4] = 9002356, 9002374
			randomID2.heroInfo, (9002356)[5] = 9002356, 9002309
			randomID2.uid = uid
			effectIds[effectIdx].army, randomID1[1] = randomID1, randomID2
			effectIds[effectIdx].id = id1
			effectIds[effectIdx].type = 4
			effectIds[effectIdx].x = myCityTilePoint.x
			;(randomX + 1).from, effectIds[effectIdx].y = effectIds[effectIdx], myCityTilePoint.y
			;(randomX + 1).id = uid .. "-" .. randomID1 .. "-" .. randomID2
			;(randomX + 1).isDuelMode = false
			;(randomX + 1).isLegendLord = false
			;(randomX + 1).isMainQueue = true
			;(randomX + 1).isNoticeWorking = false
			;(randomX + 1).isPlayerWarQueue = false
			;(randomX + 1).kingdomId = SoraDGetKid()
			;(randomX + 1).leagueID = 2961
			;(randomX + 1).matrixType = 1
			;(randomX + 1).moveLineColor = 2
			;(randomX + 1).moveLineModel = 1
			_ENV, _UPVALUE1_, (randomX + 1).moveLineType = "-", SoraDGetKid(), 1
			;("-").distancePrecent = 1
			;("-").time = 4415
			;(randomX + 1).moveTimeSpan, SoraDGetKid()[1] = SoraDGetKid(), "-"
			;(randomX + 1).playerID = uid
			;(randomX + 1).playerName = "K S R"
			;(randomX + 1).queueType = 1
			;(randomX + 1).realTotalTime = 4415
			;(randomX + 1).status = 1
			;(randomX + 1).statusEndTime = startTime + 999999
			;(randomX + 1).statusStartTime = startTime
			_ENV, (randomX + 1).teamId = startTime + 999999, 2961
			;(startTime + 999999).id = id2
			;(startTime + 999999).mapType = 6
			;(startTime + 999999).objId = 3022
			;(startTime + 999999).type = 6
			;(startTime + 999999).x = randomX
			;(randomX + 1).to, (startTime + 999999).y = startTime + 999999, randomY
			local (randomX + 1).uid, data = uid, randomX + 1
			_ENV = "-"
			;("-").msg = "MESSAGE_SERVER_WORLD_MAP_MOVELINE_ADD"
			_UPVALUE1_, ("-").lod = randomID1, 1
			;("-").data, randomID1[1] = randomID1, data
			SoraDSendMessage("-")
		end
	end
	uiManager:show("CheatCmdPop", nil)
end
function CheatViewPanel:changeVipTime()
	_ENV = nil
	;(nil).prompt = "时间(秒)支持正负数"
	;(nil).btnTitle = "修改VIP时间"
	;(nil).handle = function(inputText)
		local second = tonumber(inputText)
		if second then
			_ENV = nil
			;(nil).time = second
			cheatCtrl:reqCheat("CHANGE_LORD_VIP_TIME", nil)
		end
	end
	uiManager:show("CheatCmdPop", nil)
end
function CheatViewPanel:pngStatus()
	local showMsg = "当前下载文件："
	showMsg = showMsg .. SoraDHDResManager.curFile .. "\n可写目录下的文件：\n"
	local _ENV, tableFileName = showMsg, showMsg
	local writabelPath = cc.FileUtils:getInstance():getWritablePath() .. "hd_res/"
	local lfs = require("lfs")
	for file in lfs.dir(writabelPath) do
		if string.byte(file, 1) ~= 46 then
			showMsg = showMsg .. "【" .. file .. "】\n"
			local attr = lfs.attributes(writabelPath .. file)
			if attr.mode == "directory" then
				table.insert(tableFileName, file)
			end
		end
	end
	local _ENV, showMsg2 = (for generator), lfs.dir(writabelPath)
	for i, v in ipairs(tableFileName) do
		local filePath = writabelPath .. v
		local msg3 = "\n文件夹名：" .. v .. "\n"
		for file in lfs.dir(filePath) do
			if file ~= "." and file ~= ".." then
				msg3 = msg3 .. "【" .. file .. "】\n"
			end
		end
		table.insert(showMsg2, msg3)
	end
	local panel = SoraDCreatePanel("mailItemDetailFightDefense")
	_ENV = lfs.attributes(writabelPath .. file)
	lfs.attributes(writabelPath .. file).fightDetail = showMsg
	lfs.attributes(writabelPath .. file).manualH = true
	lfs.attributes(writabelPath .. file).otherMsg = showMsg2
	panel:initWithFightDetail(lfs.attributes(writabelPath .. file), "图片状态")
	panel:show()
end
function CheatViewPanel:cleanPng()
	local writabelPath = cc.FileUtils:getInstance():getWritablePath() .. "hd_res/"
	cc.FileUtils:getInstance():removeDirectory(writabelPath)
	BgAssetsManager:destroyInstance()
	SoraDInitHDResManager()
	SoraDShowMsgTip("清空了hd_res目录")
end
function CheatViewPanel:dayNight()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_TOGGLE_DARK"
	SoraDSendMessage(nil)
end
function CheatViewPanel:changeUser()
	_ENV = nil
	;(nil).prompt = "请输入龙腾ID"
	;(nil).btnTitle = "切换账号"
	;(nil).handle = function(inputText)
		if string.len(inputText) > 0 then
			gametop:Logout()
			SoraDShowLoginView()
			userSDKManager.userid = inputText
			SoraDConfigSet("System:LoginView:UserName~string", inputText)
			SoraDStartLoginServer()
		else
			SoraDShowMsgTip("请输入龙腾ID")
		end
	end
	uiManager:show("CheatCmdPop", nil)
end
function CheatViewPanel:cleanUser()
	_ENV = nil
	SoraDConfigSet("System:LoginView:UserList~table", nil)
	SoraDShowMsgTip("账号缓存已清空")
end
function CheatViewPanel:lowMemory()
	local devicePerformanceUtil = require("app.devicePerformanceUtil")
	if devicePerformanceUtil.memoryLevel == 0 then
		devicePerformanceUtil.memoryLevel = devicePerformanceUtil.getMemoryLevel()
	else
		devicePerformanceUtil.memoryLevel = 0
	end
	SoraDShowMsgTip("当前设备内存评级修改为：" .. devicePerformanceUtil.memoryLevel)
end
function CheatViewPanel:addArmy()
	_ENV = nil
	;(nil).style = 3
	uiManager:show("CheatItemWindow", nil)
end
function CheatViewPanel:luaMemory()
	collectgarbage("collect")
	local mem = collectgarbage("count")
	SoraDShowMsgTip(string.format("当前LUA内存占用：%fKB, %fM", mem, mem / 1024))
end
function CheatViewPanel:replayTest()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAIN_RECORD_SCREEN"
	SoraDSendMessage(nil)
end
function CheatViewPanel:switch3D()
	gEnableWorldMap3D = not gEnableWorldMap3D
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_TOGGLE_3D"
	SoraDSendMessage(nil)
end
function CheatViewPanel:toggleMapDebug()
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_TOGGLE_DEBUG"
	SoraDSendMessage(nil)
	self:closePanel()
end
function CheatViewPanel:waterSwitch()
	local imgQualityKey = "Game:GameOptionsView:showImgQuality~bool"
	_ENV = nil
	;(nil).byUID = true
	gIsGameHeighQuality = SoraDConfigGet(imgQualityKey, nil)
	gIsGameHeighQuality = not gIsGameHeighQuality
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet(imgQualityKey, gIsGameHeighQuality, nil)
	_ENV = imgQualityKey
	imgQualityKey.msg = "MESSAGE_MAINSCEN_CHANGE_IMG_QUALITY"
	SoraDSendMessage(imgQualityKey)
end
function CheatViewPanel:hideMainUI()
	_ENV = nil
	;(nil).isHideCurrentSceneView = false
	;(nil).isHideMainUI = true
	SoraDHideCurrentSceneViewAndMainUI(nil)
end
function CheatViewPanel:hideMainCity()
	local city = SoraDCurrentSceneShowView("mainCityView")
	if city then
		city.viewScrollView:setVisible(false)
	end
end
function CheatViewPanel:hideCheat()
	local currentScene = display.getRunningScene()
	local _mainUI = currentScene:currentMainUI()
	if _mainUI then
		local Button_cheat = _mainUI:getMainUITop():getTarget("Button_cheat")
		local Button_test = _mainUI:getMainUITop():getTarget("Button_test")
		Button_cheat:setVisible(false)
		Button_test:setVisible(false)
	end
	local _displayStatusLayout = SoraDGetChildByName(currentScene, "_displayStatusLayout")
	if _displayStatusLayout then
		_displayStatusLayout:setVisible(false)
	end
end
function CheatViewPanel:hideWorldMap()
	local world = SoraDCurrentSceneShowView("worldMapView")
	if world then
		world.viewScrollView:setVisible(false)
	end
end
function CheatViewPanel:reloadLua()
	ng_sys_openLuaEngine()
end
function CheatViewPanel:openMsgDump()
	_G.openMsgDump()
end
function CheatViewPanel:btnOpenLog()
	local ret = OpenLuaLog()
	SoraDShowMsgTip("打印是否开启:" .. (ret and "开" or "关"))
end
function CheatViewPanel:releaseSource()
	AppDidReceiveMemoryWarning()
end
function CheatViewPanel:textureInfo()
	local sharedTextureCache = cc.Director:getInstance():getTextureCache()
	local traceback = string.split(sharedTextureCache:getCachedTextureInfo(), "\n")
	local showMsg = ""
	for k, v in ipairs(traceback) do
		showMsg = showMsg .. v .. "\n"
	end
	local panel = SoraDCreatePanel("mailItemDetailFightDefense")
	_ENV = nil
	;(nil).fightDetail = showMsg
	;(nil).manualH = true
	panel:initWithFightDetail(nil, "纹理信息")
	panel:show()
end
function CheatViewPanel:addEquipment()
	_ENV = nil
	;(nil).style = 2
	uiManager:show("CheatItemWindow", nil)
end
function CheatViewPanel:battleAttrTest()
	SoraDCreatePanel("BattleAttrTestView"):show()
end
function CheatViewPanel:changeLordActivityState()
	cheatCtrl = nil
	cheatCtrl:reqCheat("CHANGE_LORD_ACTIVITY_STATE", nil)
end
function CheatViewPanel:changeMobilizationState()
	cheatCtrl = nil
	cheatCtrl:reqCheat("CHANGE_MOBILIZATION_STATE", nil)
end
function CheatViewPanel:openMobilization()
	cheatCtrl = nil
	cheatCtrl:reqCheat("CREATE_MOBILIZATION_ACTIVITY", nil)
end
function CheatViewPanel:changeMobilizationMember()
	_ENV = nil
	;(nil).prompt = "成员数量"
	;(nil).btnTitle = "修改成员数量"
	;(nil).handle = function(inputText)
		local minMember = tonumber(inputText) or 1
		_ENV = nil
		;(nil).minMember = minMember
		cheatCtrl:reqCheat("CHANGE_MOBILIZATION_MEMBER", nil)
	end
	uiManager:show("CheatCmdPop", nil)
end
function CheatViewPanel:changeMobilizationTime()
	_ENV = nil
	;(nil).prompt = "刷新时间"
	;(nil).btnTitle = "任务刷新时间"
	;(nil).handle = function(inputText)
		local time = tonumber(inputText) or 60
		_ENV = nil
		;(nil).time = time
		cheatCtrl:reqCheat("CHANGE_MOBILIZATION_REGENERATE", nil)
	end
	uiManager:show("CheatCmdPop", nil)
end
function CheatViewPanel:toggleWorldWater()
	local worldMap = SoraDCurrentSceneShowView("worldMapView")
	if worldMap then
		worldMap.mapLayer:setIsFilterEnable(not worldMap.mapLayer:getIsFilterEnable())
	end
end
function CheatViewPanel:changeEvilEliteTime()
	_ENV = nil
	;(nil).prompt = "魔物地宫精英时间(604750)"
	;(nil).btnTitle = "修改时间"
	;(nil).handle = function(inputText)
		local time = tonumber(inputText) or 604750
		_ENV = nil
		;(nil).time = time
		cheatCtrl:reqCheat("CHANGE_MONSTERPALACE_ELITE_TIME", nil)
	end
	uiManager:show("CheatCmdPop", nil)
end
function CheatViewPanel:changeLordLVEXP()
	_ENV = nil
	;(nil).prompt = "等级,经验"
	;(nil).btnTitle = "修改等级经验"
	;(nil).handle = function(inputText)
		if not string.split(inputText, ",") then
			local _ENV, param = string.split(inputText, ","), string.split(inputText, ",")
		end
		local level = tonumber(param[1])
		local exp = tonumber(param[2])
		if level and exp then
			_ENV = nil
			;(nil).level = level
			;(nil).exp = exp
			cheatCtrl:reqCheat("CHANGE_LORD_LEVEL_EXP", nil)
		end
	end
	uiManager:show("CheatCmdPop", nil)
end
function CheatViewPanel:setArenaTime()
	_ENV = nil
	;(nil).prompt = "竞技场时间"
	;(nil).btnTitle = "修改时间"
	;(nil).handle = function(inputText)
		local time = tonumber(inputText) or 60
		_ENV = nil
		;(nil).time = time
		cheatCtrl:reqCheat("SET_ARENA_GLOBAL_TIME", nil)
	end
	uiManager:show("CheatCmdPop", nil)
end
function CheatViewPanel:runScript()
	_ENV = nil
	;(nil).prompt = "输入脚本"
	;(nil).btnTitle = "执行脚本"
	;(nil).handle = function(inputText)
		loadstring(inputText)()
	end
	uiManager:show("CheatCmdPop", nil)
end
function CheatViewPanel:cleanPetDailyFeedEXP()
	cheatCtrl = nil
	cheatCtrl:reqCheat("CLEAN_PET_DAILY_FEED_EXP", nil)
end
function CheatViewPanel:openConsole()
	SoraDOpenConsole()
end
function CheatViewPanel:remoteDebug()
	_ENV = nil
	;(nil).prompt = "ip"
	;(nil).btnTitle = "开启调试"
	;(nil).handle = function(inputText)
		require("mobdebug").start(inputText)
	end
	uiManager:show("CheatCmdPop", nil)
end
function CheatViewPanel:fabric()
	_ENV = nil
	_ENV, (nil).isAgree = nil, true
	;(nil).byUID = true
	SoraDConfigSet("Game:GetCrashlytics:track~table", nil, nil)
	userSDKManager.setFabricEnable(true)
end
function CheatViewPanel:richTextTest()
	SoraDCreatePanel("htmlRichTestView"):show()
end
function CheatViewPanel:chatTest()
	local consoleClient = include("consoleClient").new()
	consoleClient:testPythonSocket()
end
function CheatViewPanel:toggleChatDebug()
	gChatDebug = not gChatDebug
	cc.Device:setIsHtmlTextDebug(gChatDebug)
end
function CheatViewPanel:resetPopTime()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:MainCityView:saveTime~integer", 0, nil)
end
function CheatViewPanel:connect2LogServer()
	local ip = "127.0.0.1"
	local test = display.getRunningScene():getTest()
	test.connectToLogServer(ip, 52137)
end
function CheatViewPanel:createCtrl()
	_ENV = nil
	;(nil).content = "把文件信息配置到createCtrlTool:initConfig()里再过来点生成文件"
	;(nil).confirmString = "生成文件"
	;(nil).confirmFunc = function()
		package.loaded["app.tools.createCtrlTool"] = nil
		require("app.tools.createCtrlTool").new()
	end
	uiManager:show("MessageBox", nil)
end
function CheatViewPanel:createActivity()
	_ENV = nil
	;(nil).content = "把文件信息配置到createCtrlTool:createNormalActivity()里再过来点生成文件"
	;(nil).confirmString = "生成文件"
	;(nil).confirmFunc = function()
		package.loaded["app.tools.createCtrlTool"] = nil
		require("app.tools.createCtrlTool"):createNormalActivity()
	end
	uiManager:show("MessageBox", nil)
end
function CheatViewPanel:radianceWar()
	local radianceWarUtil = include("radianceWarUtil")
	radianceWarUtil.toogleRelease()
end
function CheatViewPanel:scaleConfig()
	local worldMap = SoraDCurrentSceneShowView("worldMapView")
	if worldMap then
		local comDebug = worldMap:getComponent("worldMapComDebugInfo")
		if comDebug then
			comDebug:initDebugView()
		end
	end
end
function CheatViewPanel:heroReview()
	uiManager:show("CheatHeroReview")
end
function CheatViewPanel:btnTest()
	uiManager:show("test")
end
function CheatViewPanel:switchMode()
	GAME_SWITCH_MODE = not GAME_SWITCH_MODE
	SoraDShowMsgTip("内外城切换动画" .. (GAME_SWITCH_MODE and "关闭" or "开启"))
end
function CheatViewPanel:nebulaAllStarCheat()
	local nebulaAllStarUtil = include("nebulaAllStarUtil")
	local nebulaAllStarRead = include("nebulaAllStarRead")
	local trueFun = function()
		return true
	end
	nebulaAllStarUtil.checkIsInForbidArea = trueFun
	nebulaAllStarUtil.checkIsCanTransfer = trueFun
	nebulaAllStarUtil.checkIsCanZhanling = trueFun
	nebulaAllStarUtil.checkSelfCityPos = trueFun
	nebulaAllStarRead.checkGiftType = trueFun
	local falseFun = function()
		return false
	end
	nebulaAllStarUtil.checkForbitTipButtonType = falseFun
	nebulaAllStarUtil.checkForbitRandomMove = falseFun
end
function CheatViewPanel:nebulaAllStarSpoilQueue()
	local nebulaAllStarUtil = include("nebulaAllStarUtil")
	nebulaAllStarUtil.sendTestSpoilQueue()
	self:close()
end
function CheatViewPanel:heroTrial()
	SoraDCreatePanel("heroTrialView"):show()
end
function CheatViewPanel:gotoDownURl()
	local url = SoraDGetDownLoadURL()
	if url and string.len(url) > 0 then
		device.openURL(url)
	end
end
function CheatViewPanel:loginNoticeTest()
	local panel = uiManager:show("CommonMaintainView").view
	panel:initData(os.time())
	panel:loadWeb("https://eventtest.onemt.co/game/eventnotice/notice?appid=100000601&kid=1&lang=ar")
end
function CheatViewPanel:roaringFlameWarGuide(...)
	SoraDRemoveAllPanelFromManager()
	if not worldMapDefine.isRoaringFlameKingdomID() then
		local kid = GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.START
		local max = worldMapDefine.getMaxCoordinateByKid(kid)
		SoraDGotoWorldMapPoint(cc.p(max * 0.5, max * 0.5), false, kid, nil, nil, true)
	elseif not worldMapDefine.getWorldMapView() then
		SoraDGotoWorldMapPoint()
	end
	_ENV = worldMapDefine.getMaxCoordinateByKid(kid)
	worldMapDefine.getMaxCoordinateByKid(kid).msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
	worldMapDefine.getMaxCoordinateByKid(kid).step = 1230100
	SoraDSendMessage((worldMapDefine.getMaxCoordinateByKid(kid)))
end
function CheatViewPanel:roaringFlameWarBuild(...)
	self:close()
	uiManager:show("RoaringFlameWarBuildTest")
end
function CheatViewPanel:roaringFlameWarMap(...)
	self:close()
	uiManager:show("RoaringFlameWarMap")
end
function CheatViewPanel:linkLinkGame()
	uiManager:show("LinkLinkView")
end
function CheatViewPanel:roadRoughGame()
	uiManager:show("RoadRoughView")
end
function CheatViewPanel:shootGame()
	uiManager:show("ForeignPShootGame")
end
function CheatViewPanel:puzzleGame()
	uiManager:show("PuzzleGame")
end
function CheatViewPanel:sneakSnipeGame()
	_ENV = nil
	;(nil).sceneType = gSnipeSceneType.WALL
	uiManager:show("SneakSnipeGame", nil)
end
function CheatViewPanel:sneakSnipeGame2()
	_ENV = nil
	;(nil).sceneType = gSnipeSceneType.RANGE
	uiManager:show("SneakSnipeGame", nil)
end
function CheatViewPanel:sneakSnipeGame3()
	_ENV = nil
	;(nil).sceneType = gSnipeSceneType.SQUARE
	uiManager:show("SneakSnipeGame", nil)
end
function CheatViewPanel:bulletGame()
	_ENV = nil
	;(nil).level = 1
	uiManager:show("bulletGame", nil)
end
function CheatViewPanel:newEliminateGame()
	include("starsWishingGameCommon").enterGame()
	self:close()
end
function CheatViewPanel:open9001676Game()
	uiManager:show("Activity_9001676_Main")
end
function CheatViewPanel:sheepSheepGame()
	uiManager:show("SheepSheepGame")
end
function CheatViewPanel:fiveTenKGame()
	uiManager:show("FiveTenKGame")
end
function CheatViewPanel:numberGame()
	uiManager:show("NumberGame")
end
function CheatViewPanel:clearLocalData()
	cc.UserDefault:getInstance():clearAll()
end
function CheatViewPanel:userAccountInfo()
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local pyramidWarCtrl = SoraDGetCtrl("pyramidWarCtrl")
	local allianceId = allianceMgr:getOwnAid()
	local teamId = allianceMgr:getOwnTeamID()
	local kingdomID = gametop.playertop_:getMapID()
	local legionId = pyramidWarCtrl:getOwnLegion() and pyramidWarCtrl:getOwnLegion().legionId or 0
	local nebulaWarUtil = include("nebulaWarUtil")
	local group = nebulaWarUtil.getRegionGroup()
	local str = "真实UID:" .. gametop.playertop_:getPlayerID() .. [[

aid:]] .. tostring(allianceId) .. [[

tid:]] .. tostring(teamId) .. [[

kid:]] .. tostring(kingdomID) .. [[

gid:]] .. tostring(legionId) .. [[

group:]] .. tostring(group)
	SoraDShowMsgBox(str)
end
function CheatViewPanel:oldCheatView()
	SoraDCreatePanel("cheatView"):show()
	self:close()
end
function CheatViewPanel:MicEnable()
	local CSUserSDKManager = CS.Sultan.Manager.UserSDKManager.GetInstance()
	CSUserSDKManager:SetupOutputCategoryForMic(true)
end
function CheatViewPanel:MicDisable()
	local CSUserSDKManager = CS.Sultan.Manager.UserSDKManager.GetInstance()
	CSUserSDKManager:SetupOutputCategoryForMic(false)
end
function CheatViewPanel:manorCityEnter()
	local manorCityUtil = include("manorCityUtil")
	manorCityUtil.gotoGardenCity()
	self:closePanel()
end
function CheatViewPanel:manorWarEnter()
	local manorCityUtil = include("manorCityUtil")
	manorCityUtil.gotoGardenWar()
end
function CheatViewPanel:manorReset()
	self:local_czzy()
end
function CheatViewPanel:manorUnlock()
	self:local_jszy()
end
return CheatViewPanel
