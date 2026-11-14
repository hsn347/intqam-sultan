local activity_9001661_Ctrl = SoraDGetCtrl("activity_9001661_Ctrl")
local activity_9001661_Read = include("activity_9001661_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_reward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001661/Com_reward", Com_reward)
function Com_reward:onInit()
	local Text_lv = self.fields.Label_lv:getChild("Text_lv")
	Text_lv:setString("lv")
	self.fields.Text_Title2:setString(i18n("commandhall_text_56"))
	self.fields.Text_Title3:setString(i18n("datepalm_tree_text18"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.bar:hideTitle()
end
function Com_reward:onShow()
	local growthValue = activity_9001661_Ctrl:getGrowthValue()
	self.curLv = activity_9001661_Read.getLevelByExp(growthValue)
	self.fields.Label_lv:setString(self.curLv)
	local lvMax = activity_9001661_Read.getLevelMax()
	if self.curLv == lvMax then
		self.fields.bar:setMax(1)
		self.fields.bar:setValue(1)
		self.fields.Text_progress:setString(i18n("hero_text_41"))
	else
		local nextLv = self.curLv + 1
		local curExp = activity_9001661_Read.getLevelConfigExp(self.curLv)
		local nextExp = activity_9001661_Read.getLevelConfigExp(nextLv)
		local expMax = nextExp - curExp
		self.fields.bar:setMax(expMax)
		self.fields.bar:setValue(growthValue - curExp)
		activity_9001661_Ctrl = i18n("hero_text_41")
		i18n("hero_text_41").cur = growthValue - curExp
		i18n("hero_text_41").next = expMax
		self.fields.Text_progress:setString(i18n("%{cur}/%{next}", i18n("hero_text_41")))
	end
	self.config = activity_9001661_Read.getAllLevelConfig()
	local showNum = 20
	self.showLv = math.min(self.curLv, lvMax - showNum + 1)
	self.fields.List:setNumItems(showNum)
	if self.showLv < self.curLv then
		self.fields.List:scrollToView(self.curLv - self.showLv)
	end
end
function Com_reward:onItemRenderer(index, obj)
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
		obj._controllers = fguiHelper.get_controllers(obj)
	end
	local showLv = self.showLv + index
	local cfg = self.config[showLv]
	local _fields = obj._fields
	local _controllers = obj._controllers
	if cfg.level == self.curLv then
		_controllers.c1:setSelectedIndex(1)
	else
		_controllers.c1:setSelectedIndex(0)
	end
	_ENV = 0
	;(0).size = 22
	local lvStr = SoraDWrapHtmlTagByStyle(cfg.level, 0)
	_fields.Text_lv:setString("lv" .. "\n" .. lvStr)
	local nexLvCfg = self.config[showLv + 1]
	_UPVALUE2_ = showLv + 1
	if not nexLvCfg or not nexLvCfg.levelitem then
		_ENV = nexLvCfg.levelitem
	end
	if not cfg.dailyitem then
		_ENV = cfg.dailyitem
	end
	;(showLv + 1)[1] = nexLvCfg.levelitem
	local (showLv + 1)[2], rewards = cfg.dailyitem, showLv + 1
	for i, reward in ipairs(rewards) do
		local Com_item = _fields["Com_Item" .. i]
		local itemID, itemCount = reward[1], reward[2]
		if itemID then
			Com_item:setVisible(true)
			Com_item:initData(itemID, itemCount)
		else
			Com_item:setVisible(false)
		end
	end
end
return Com_reward
