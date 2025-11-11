// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Sleep_report_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSleepReportCollection on Isar {
  IsarCollection<SleepReport> get sleepReports => this.collection();
}

const SleepReportSchema = CollectionSchema(
  name: r'SleepReport',
  id: -602473489360408529,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'deepSleepPercent': PropertySchema(
      id: 1,
      name: r'deepSleepPercent',
      type: IsarType.long,
    ),
    r'durationInMinutes': PropertySchema(
      id: 2,
      name: r'durationInMinutes',
      type: IsarType.long,
    ),
    r'remSleepPercent': PropertySchema(
      id: 3,
      name: r'remSleepPercent',
      type: IsarType.long,
    ),
    r'sleepScore': PropertySchema(
      id: 4,
      name: r'sleepScore',
      type: IsarType.double,
    )
  },
  estimateSize: _sleepReportEstimateSize,
  serialize: _sleepReportSerialize,
  deserialize: _sleepReportDeserialize,
  deserializeProp: _sleepReportDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _sleepReportGetId,
  getLinks: _sleepReportGetLinks,
  attach: _sleepReportAttach,
  version: '3.1.0+1',
);

int _sleepReportEstimateSize(
  SleepReport object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _sleepReportSerialize(
  SleepReport object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeLong(offsets[1], object.deepSleepPercent);
  writer.writeLong(offsets[2], object.durationInMinutes);
  writer.writeLong(offsets[3], object.remSleepPercent);
  writer.writeDouble(offsets[4], object.sleepScore);
}

SleepReport _sleepReportDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SleepReport(
    date: reader.readDateTime(offsets[0]),
    deepSleepPercent: reader.readLong(offsets[1]),
    durationInMinutes: reader.readLong(offsets[2]),
    remSleepPercent: reader.readLong(offsets[3]),
    sleepScore: reader.readDouble(offsets[4]),
  );
  object.id = id;
  return object;
}

P _sleepReportDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sleepReportGetId(SleepReport object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sleepReportGetLinks(SleepReport object) {
  return [];
}

void _sleepReportAttach(
    IsarCollection<dynamic> col, Id id, SleepReport object) {
  object.id = id;
}

extension SleepReportQueryWhereSort
    on QueryBuilder<SleepReport, SleepReport, QWhere> {
  QueryBuilder<SleepReport, SleepReport, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension SleepReportQueryWhere
    on QueryBuilder<SleepReport, SleepReport, QWhereClause> {
  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> dateNotEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SleepReportQueryFilter
    on QueryBuilder<SleepReport, SleepReport, QFilterCondition> {
  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      deepSleepPercentEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deepSleepPercent',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      deepSleepPercentGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deepSleepPercent',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      deepSleepPercentLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deepSleepPercent',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      deepSleepPercentBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deepSleepPercent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      durationInMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationInMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      durationInMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationInMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      durationInMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationInMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      durationInMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationInMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      remSleepPercentEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remSleepPercent',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      remSleepPercentGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remSleepPercent',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      remSleepPercentLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remSleepPercent',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      remSleepPercentBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remSleepPercent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      sleepScoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sleepScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      sleepScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sleepScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      sleepScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sleepScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      sleepScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sleepScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension SleepReportQueryObject
    on QueryBuilder<SleepReport, SleepReport, QFilterCondition> {}

extension SleepReportQueryLinks
    on QueryBuilder<SleepReport, SleepReport, QFilterCondition> {}

extension SleepReportQuerySortBy
    on QueryBuilder<SleepReport, SleepReport, QSortBy> {
  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByDeepSleepPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deepSleepPercent', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByDeepSleepPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deepSleepPercent', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByDurationInMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByDurationInMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByRemSleepPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remSleepPercent', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByRemSleepPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remSleepPercent', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortBySleepScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepScore', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortBySleepScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepScore', Sort.desc);
    });
  }
}

extension SleepReportQuerySortThenBy
    on QueryBuilder<SleepReport, SleepReport, QSortThenBy> {
  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByDeepSleepPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deepSleepPercent', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByDeepSleepPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deepSleepPercent', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByDurationInMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByDurationInMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByRemSleepPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remSleepPercent', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByRemSleepPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remSleepPercent', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenBySleepScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepScore', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenBySleepScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepScore', Sort.desc);
    });
  }
}

extension SleepReportQueryWhereDistinct
    on QueryBuilder<SleepReport, SleepReport, QDistinct> {
  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct>
      distinctByDeepSleepPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deepSleepPercent');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct>
      distinctByDurationInMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationInMinutes');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct>
      distinctByRemSleepPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remSleepPercent');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctBySleepScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sleepScore');
    });
  }
}

extension SleepReportQueryProperty
    on QueryBuilder<SleepReport, SleepReport, QQueryProperty> {
  QueryBuilder<SleepReport, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SleepReport, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<SleepReport, int, QQueryOperations> deepSleepPercentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deepSleepPercent');
    });
  }

  QueryBuilder<SleepReport, int, QQueryOperations> durationInMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationInMinutes');
    });
  }

  QueryBuilder<SleepReport, int, QQueryOperations> remSleepPercentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remSleepPercent');
    });
  }

  QueryBuilder<SleepReport, double, QQueryOperations> sleepScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sleepScore');
    });
  }
}
