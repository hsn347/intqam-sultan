local ltBase = include("ltBase")
local babelTowerRead = class("babelTowerRead", ltBase, include("aAReadClass").new())
function babelTowerRead:ctor()
	babelTowerRead.super.ctor(self)
end
local isInited = false
function babelTowerRead:init()
	if isInited then
		return
	end
	_UPVALUE1_ = nil
	;(nil)[1] = "promise_summit_reward_show"
	self:defineValue("towerAwardConfig", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "promise_summit_config"
	;(nil)[2] = true
	self:defineValue("towerConfig", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "promise_summit_rank_reward"
	;(nil)[2] = true
	self:defineValue("rankAward", nil)
	self:defineValue("buffConfig", function()
		_UPVALUE0_, _UPVALUE5_ = nil, nil
		;(nil).describe = "Promise_Summit_buff_01"
		;(nil).imgLbg = "frame_ttt_buffcell_01.png"
		;(nil).imgIcon = "frame_ttt_bufficon_01.png"
		_UPVALUE0_, (nil).imgQbg = nil, "frame_ttt_buffimg_01.png"
		;(nil).describe = "Promise_Summit_buff_02"
		;(nil).imgLbg = "frame_ttt_buffcell_03.png"
		;(nil).imgIcon = "frame_ttt_bufficon_03.png"
		_UPVALUE0_, (nil).imgQbg = nil, "frame_ttt_buffimg_03.png"
		;(nil).describe = "Promise_Summit_buff_04"
		;(nil).imgLbg = "frame_ttt_buffcell_02.png"
		;(nil).imgIcon = "frame_ttt_bufficon_02.png"
		_UPVALUE0_, (nil).imgQbg = nil, "frame_ttt_buffimg_02.png"
		;(nil).describe = "Promise_Summit_buff_03"
		;(nil).imgLbg = "frame_ttt_buffcell_04.png"
		;(nil).imgIcon = "frame_ttt_bufficon_03.png"
		_UPVALUE0_, (nil).imgQbg = nil, "frame_ttt_buffimg_04.png"
		;(nil).describe = "Promise_Summit_buff_04"
		;(nil).imgLbg = "frame_ttt_buffcell_02.png"
		;(nil).imgIcon = "frame_ttt_bufficon_02.png"
		;(nil).imgQbg = "frame_ttt_buffimg_02.png"
		;(nil)[1] = nil
		;(nil)[2] = nil
		;(nil)[3] = nil
		;(nil)[4] = nil
		;(nil)[5] = nil
		return nil
	end)
end
function babelTowerRead:getTowerAward()
	return self.towerAwardConfig
end
function babelTowerRead:getRankReward()
	return self.rankAward
end
function babelTowerRead:getTowerNum()
	return table.nums(self.towerConfig)
end
function babelTowerRead:getProperty(t, itemID, property)
	return babelTowerRead.super.getProperty(self, t, itemID, property)
end
function babelTowerRead:getBoxReward(index)
	return self:getProperty(self.towerConfig, index, "boxReward")
end
function babelTowerRead:getBaseReward(index)
	return self:getProperty(self.towerConfig, index, "baseReward")
end
function babelTowerRead:getBuffList(index)
	_UPVALUE2_ = self
	self[1] = "buffType"
	self[2] = "buffValue"
	if not serviceFunctions.tableFormat(self:getProperty(self.towerConfig, index, "buff"), self) then
		_ENV = serviceFunctions.tableFormat(self:getProperty(self.towerConfig, index, "buff"), self)
	end
	return (serviceFunctions.tableFormat(self:getProperty(self.towerConfig, index, "buff"), self))
end
function babelTowerRead:getCostItemAndNum(index)
	return self:getProperty(self.towerConfig, index, "item")
end
function babelTowerRead:getBuffConfig(index)
	return self.buffConfig[index]
end
function babelTowerRead:getEventType(index, eventIndex)
	local eventList = self:getProperty(self.towerConfig, index, "event")
	_UPVALUE3_ = index
	index[1] = "eventType"
	index[2] = "eventValue"
	index[3] = "rate"
	eventList = serviceFunctions.tableFormat(eventList, index)
	return eventList[eventIndex].eventType
end
babelTowerRead:init()
return babelTowerRead
