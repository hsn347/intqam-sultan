local ramadanWorldExplorerRead = include("ramadanWorldExplorerRead")
local baseComponent = require("fgui.base.baseComponent")
local com_quest = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RamadanWorldExplorer/com_quest", com_quest)
function com_quest:onInit()
	self.config = ramadanWorldExplorerRead.getAnswerConfig()
	self.fields.Answer_List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Answer_List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
end
function com_quest:onShow()
	self:updateView()
end
function com_quest:updateView()
	SoraDCloseLoading()
	serviceFunctions.setRandomSeed()
	local index = math.random(1, #self.config)
	if self.index == index then
		index = math.random(1, #self.config)
	end
	self.index = index
	print(self.index, "self.index")
	self.answerInfo = self.config[self.index]
	self.fields.text_des:setString(i18n(self.answerInfo.topickey))
	self.fields.Answer_List:setNumItems(4)
end
function com_quest:onItemRenderer(index, target)
	target:setSelected(false)
	target:setString(i18n(self.answerInfo["answer" .. index + 1]))
end
function com_quest:onClickItem(target)
	SoraDPlaySound()
	local chooseIndex = self.fields.Answer_List:getSelectedIndex() + 1
	if chooseIndex == self.answerInfo.correct then
		_ENV = nil
		;(nil).msg = "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE"
		;(nil).isWin = true
		SoraDSendMessage(nil)
	else
		SoraDShowMsgTip(i18n("ramadan_world_explorer_text_0012"))
		SoraDShowLoading()
		_UPVALUE1_ = i18n("ramadan_world_explorer_text_0012")
		i18n("ramadan_world_explorer_text_0012")[1] = ffa.delay(0.2)
		i18n("ramadan_world_explorer_text_0012")[2] = ffa.callFunc(function()
			self:updateView()
		end)
		i18n("ramadan_world_explorer_text_0012")[3] = ffa.callFunc(function()
			self:updateView()
		end)
		self:runAction(ffa.seq(i18n("ramadan_world_explorer_text_0012")))
	end
end
return com_quest
