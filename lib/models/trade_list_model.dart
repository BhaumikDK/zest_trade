import 'package:json_annotation/json_annotation.dart';
import 'package:zest_trade/models/user_model.dart';
import 'package:zest_trade/utils/app_constant.dart';

part 'trade_list_model.g.dart';

@JsonSerializable()
class TradeModel {
  @JsonKey(name: ApiConstant.ID)
  final int? id;

  @JsonKey(name: ApiConstant.MENTOR_ID)
  final int? mentorId;

  @JsonKey(name: ApiConstant.TYPE)
  final String? type;

  @JsonKey(name: ApiConstant.ENTRY_PRICE)
  final int? entryPrice;

  @JsonKey(name: ApiConstant.NAME)
  final String? name;

  @JsonKey(name: ApiConstant.STOCK)
  final String? stock;

  @JsonKey(name: ApiConstant.EXIT_PRICE)
  final int? exitPrice;

  @JsonKey(name: ApiConstant.EXIT_HIGH)
  final int? exitHigh;

  @JsonKey(name: ApiConstant.STOP_LOSS_PRICE)
  final int? stopLossPrice;

  @JsonKey(name: ApiConstant.ACTION)
  final String? action;

  @JsonKey(name: ApiConstant.RESULT)
  final String? result;

  @JsonKey(name: ApiConstant.STATUS)
  final String? status;

  @JsonKey(name: ApiConstant.PROVIDED_DATE)
  final String? providedDate;

  @JsonKey(name: ApiConstant.FEE)
  final String? fee;

  @JsonKey(name: ApiConstant.ISSUBSCRIBE)
  final int? isSubscribe;

  @JsonKey(name: ApiConstant.USER)
  final UserModel? user;

  TradeModel({
    this.id,
    this.mentorId,
    this.type,
    this.entryPrice,
    this.name,
    this.stock,
    this.exitPrice,
    this.exitHigh,
    this.stopLossPrice,
    this.action,
    this.result,
    this.status,
    this.providedDate,
    this.fee,
    this.isSubscribe,
    this.user,
  });

  factory TradeModel.fromJson(Map<String, dynamic> json) =>
      _$TradeModelFromJson(json);
  Map<String, dynamic> toJson() => _$TradeModelToJson(this);
}
