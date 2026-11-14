# -*- coding: utf-8 -*-
"""
tasks — حزمة مهام البوت المستقلة للعبة انتقام السلاطين
"""

from tasks.base_task import BaseTask, TaskResult
from tasks.port import PortTask
from tasks.merchant_ship import MerchantShipTask
from tasks.treasure import TreasureTask
from tasks.city_harvest import CityHarvestTask
from tasks.train import TrainTask
from tasks.shield import ShieldTask
from tasks.research import ResearchTask
from tasks.flower import FlowerTask
from tasks.wonder_merchant import WonderMerchantTask
from tasks.imperial_mausoleum import ImperialMausoleumTask
from tasks.pet import PetTask
from tasks.material_synthesis import MaterialSynthesisTask
from tasks.forge_equipment import ForgeEquipmentTask
from tasks.cure_wounded import CureWoundedTask
from tasks.alliance import AllianceTask
from tasks.war_medal import WarMedalTask
from tasks.daily_train import DailyTrainTask
from tasks.building import BuildingTask
from tasks.command_hall import CommandHallTask
from tasks.daily_quest import DailyQuestTask

__all__ = [
    "BaseTask",
    "TaskResult",
    "PortTask",
    "MerchantShipTask",
    "TreasureTask",
    "CityHarvestTask",
    "TrainTask",
    "DailyTrainTask",
    "BuildingTask",
    "ShieldTask",
    "ResearchTask",
    "FlowerTask",
    "WonderMerchantTask",
    "ImperialMausoleumTask",
    "PetTask",
    "MaterialSynthesisTask",
    "ForgeEquipmentTask",
    "CureWoundedTask",
    "AllianceTask",
    "WarMedalTask",
    "CommandHallTask",
    "DailyQuestTask",
]
