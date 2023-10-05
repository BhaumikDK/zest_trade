import 'package:json_annotation/json_annotation.dart';
import 'package:zest_trade/utils/app_constant.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: ApiConstant.ID)
  final int? id;

  @JsonKey(name: ApiConstant.NAME)
  final String? name;

  @JsonKey(name: ApiConstant.PROFILE_IMAGE)
  final String? profileImage;

  UserModel({this.id, this.name, this.profileImage});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
