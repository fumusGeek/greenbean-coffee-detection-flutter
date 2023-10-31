// ignore_for_file: unused_local_variable
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

//check input shape
import 'package:tflite_flutter/tflite_flutter.dart';

class DeteksiController extends GetxController {
  Set<String> addedLabels = {};

  Rx<File?> image = Rx<File?>(null);
  RxList<dynamic> recognitions = <dynamic>[].obs;
  File? picture;
  List<String> labelForDescriptions = [];
  List<String> croppedImageLabel = [];
  List<String> angkaStrings = [];
  Interpreter? _interpreter;
  Uint8List? images;
  double? totalMutu;
  List<Uint8List> croppedImageList = [];
  List<String> deskripsiLabels = [];
  final totalLabel = <String, dynamic>{};
  // var mutuTotal = <String, dynamic>{};
  var gradeTotal;
  var scores;
  var numberOfDetections;
  Map<String, String> deskripsi = {
    'hitam':
        'biji kopi yang setengah atau lebih dari bagian luarnya berwarna hitam baik yang mengkilap maupun keriput',
    'kulit_besar':
        'kulit majemuk (pericarp) dari kopi gelondong dengan atau tanpa kulit ari (silver skin) dan kulit tanduk (parchment) di dalamnya, yang berukuran lebih besar dari ¾ bagian kulit majemuk yang utuh ',
    'batu_besar': ' batu berukuran panjang atau diameter lebih dari 10 mm',
    'ranting_besar': 'ranting berukuran panjang atau diameter lebih dari 10 mm',
    'tanah_besar': 'tanah berukuran panjang atau diameter lebih dari 10 mm',
    'hitam_sebagian':
        'biji kopi yang kurang dari setengah bagian luarnya berwarna hitam, atau satu bintik hitam kebiru-biruan tetapi tidak berlubang atau ditemukan lubang dengan warna hitam yang lebih besar dari lubang tersebut ',
    'hitam_pecah':
        'biji kopi yang berwarna hitam tidak utuh, berukuran sama dengan atau kurang dari ¾ bagian biji utuh,atau biji hitam sebagian yang pecah ',
    'gelondong':
        'buah kopi kering yang masih terbungkus dalam kulit majemuknya, baik dalam keadaan utuh maupun besarnya sama atau lebih dari ¾ bagian kulit majemuk yang utuh',
    'coklat':
        'biji kopi yang setengah atau lebih bagian luarnya berwarna coklat, yang lebih tua dari populasinya, baik yang mengkilap maupun keriput. Biji coklat yang pecah dinilai sebagai biji pecah ',
    'kulit_sedang':
        'kulit majemuk dari kopi gelondong dengan atau tanpa kulit ari dan kulit tanduk di dalamnya, yang berukuran ½ sampai dengan ¾ bagian kulit majemuk yang utuh ',
    'kulit_kecil':
        'kulit majemuk dari kopi gelondong dengan atau tanpa kulit ari dan kulit tanduk di dalamnya, yang berukuran kurang dari ½ bagian kulit majemuk yang utuh',
    'biji_tanduk':
        'biji kopi yang masih terbungkus oleh kulit tanduk, yang membungkus biji tersebut dalam keadaan utuh maupun besarnya sama dengan atau lebih besar dari ¾ bagian kulit tanduk utuh',
    'kulit_tanduk_besar':
        'kulit tanduk yang terlepas atau tidak terlepas dari biji kopi, yang berukuran lebih besar dari ¾ bagian kulit tanduk utuh',
    'kulit_tanduk_sedang':
        'kulit tanduk yang terlepas atau tidak terlepas dari biji kopi yang berukuran ½ sampai ¾ bagian kulit tanduk utuh',
    'kulit_tanduk_kecil':
        'kulit tanduk yang terlepas dari biji kopi yang berukuran kurang dari ½ bagian kulit tanduk yang utuh',
    'pecah':
        'biji kopi yang tidak utuh yang besarnya sama atau kurang dari ¾ bagian biji yang utuh',
    'muda': 'biji kopi yang kecil dan keriput pada seluruh bagian luarnya',
    'lubang_satu': 'biji kopi yang berlubang satu akibat serangan serangga',
    'lubang_lebih_dari_satu':
        'biji kopi yang berlubang lebih dari satu akibat serangan serangga',
    'batu_sedang': 'batu berukuran panjang atau diameter 5 mm -10 mm',
    'tanah_sedang': 'tanah berukuran panjang atau diameter 5 mm -10 mm',
    'ranting_sedang': 'ranting berukuran panjang atau diameter 5 mm -10 mm',
    'batu_kecil': 'batu berukuran panjang atau diameter kurang dari 5 mm',
    'ranting_kecil': 'ranting berukuran panjang atau diameter kurang dari 5 mm',
    'tanah_kecil': 'tanah berukuran panjang atau diameter kurang dari 5 mm'
  };
  String? mutu;

  //test yang baru
  static const String _modelPath = 'assets/model/new_model/detect.tflite';
  static const String _labelPath = 'assets/model/new_model/labelmap.txt';
  var isLoading = false.obs;

  List<String>? _labels;
  String? deskripsiLabel;

  Future pickImage() async {
    // isLoading(true);
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    update();

    if (pickedImage == null) return;
    images = analyseImage(pickedImage.path);

    // print('the images is $images');
  }

  Future<void> pickCamera() async {
    final pickedCamera =
        await ImagePicker().pickImage(source: ImageSource.camera);

    update();

    if (pickedCamera == null) return;
    images = analyseImage(pickedCamera.path);
  }

  //load model fungsi baru
  Future<void> _loadModel() async {
    log('Loading interpreter options...');
    final interpreterOptions = InterpreterOptions();

    // Use XNNPACK Delegate
    if (Platform.isAndroid) {
      interpreterOptions.addDelegate(XNNPackDelegate());
    }

    // Use Metal Delegate
    if (Platform.isIOS) {
      interpreterOptions.addDelegate(GpuDelegate());
    }

    log('Loading interpreter...');
    _interpreter =
        await Interpreter.fromAsset(_modelPath, options: interpreterOptions);
  }

  //load labels
  Future<void> _loadLabels() async {
    log('Load labels...');
    final labelsRaw = await rootBundle.loadString(_labelPath);
    _labels = labelsRaw.split('\n');
  }

  Uint8List analyseImage(String imagePath) {
    log('Analyzing image...');
    //read gambar byets dari file yang dipilih
    final imageData = File(imagePath).readAsBytesSync();

    //decode gambarnya
    final image = img.decodeImage(imageData);

    //resize gambar sesuai dengan ukuran model (input tensors) [320,320] (h,w)
    final imageInput = img.copyResize(
      image!,
      width: 640,
      height: 640,
    );

    //buat representasi matriks dari h,w, dan rgg [640,640,3]
    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(
        imageInput.width,
        (x) {
          final pixel = imageInput.getPixel(x, y);
          return [pixel.r, pixel.g, pixel.b];
        },
      ),
    );
    final inputMean = 127.5;
    final inputStd = 127.5;
    final floatImageMatrix = parseNumToDouble(imageMatrix);
    // print(floatImageMatrix);

    final result = floatImageMatrix.map((element) {
      return element.map((item) {
        return item.map((num) => (num - inputMean) / inputStd).toList();
      }).toList();
    }).toList();

    final output = _runInference(result);

    log('Processing outputs...');
    //ngambil lokasi dari output tensor [1,10,4]
    final locationsRaw = output.elementAt(1).first as List<List<double>>;
    final locations = locationsRaw.map((list) {
      return list.map((value) => (value * 640).toInt()).toList();
    }).toList();
    log('Locations: $locations');

    // Classes
    final classesRaw = output.last.first as List<double>;
    log('Raw: $classesRaw');
    final classes = classesRaw.map((value) => value.toInt()).toList();
    log('Classes: $classes');

    // Scores
    scores = output.first.first as List<double>;
    //take only 2 digits after 0.
    // for (double nilaiDouble in scores) {
    //   int firstNum = (nilaiDouble * 100).toInt() % 100;
    //   String angkaString = firstNum.toString();

    //   if (angkaString.length == 1) {
    //     angkaString = "0" + angkaString;
    //   }

    //   angkaStrings.add(angkaString);
    // }

    // Number of detections
    final numberOfDetectionsRaw = output.elementAt(2).first as double;
    numberOfDetections = numberOfDetectionsRaw.toInt();
    log('Number of detections: $numberOfDetections');

    log('Classifying detected objects...');
    final List<String> classication = [];
    log('the labels is: $_labels and the scores is $scores');
    for (var i = 0; i < numberOfDetections; i++) {
      classication.add(_labels![classes[i]]);
    }

    log('Outlining objects...');
    croppedImageList.clear();
    croppedImageLabel.clear();
    totalLabel.clear();
    deskripsiLabels.clear();
    addedLabels.clear();
    angkaStrings.clear();
    labelForDescriptions.clear();

    final List<String> modifiedClass =
        classication.map((e) => e.replaceAll(RegExp(r'\d'), '')).toList();

    log('isi modified class is $modifiedClass');
    //adding description on classification labels

    //adding description

    log('label yang double adalah $addedLabels');
    for (var i = 0; i < numberOfDetections; i++) {
      if (scores[i] > 0.5 && scores[i] <= 1.0) {
        // Rectangle drawing
        final croppedImage = img.drawRect(
          imageInput,
          x1: locations[i][1],
          y1: locations[i][0],
          x2: locations[i][3],
          y2: locations[i][2],
          color: img.ColorRgb8(255, 0, 0),
          thickness: 4,
        );

        // crop the image
        final newCroppedImage = img.copyCrop(
          imageInput,
          x: locations[i][1],
          y: locations[i][0],
          width: locations[i][3] - locations[i][1],
          height: locations[i][2] - locations[i][0],
        );

        // // encode to byte
        final jpgFile = img.encodeJpg(newCroppedImage);
        croppedImageList.add(jpgFile);

        //added percentage
        int firstNum = (scores[i] * 100).toInt() % 100;
        String angkaString = firstNum.toString();

        angkaStrings.add(angkaString);
        log('${scores[i]}');

        //added desc
        String label = modifiedClass[i];
        if (!addedLabels.contains(label)) {
          String deskripsiLabel = deskripsi[label] ?? "Deskripsi not available";
          labelForDescriptions.add(label);
          deskripsiLabels.add(deskripsiLabel);
          addedLabels.add(label); // Tandai label sebagai sudah ditambahkan
        }

        /// Save label to list
        croppedImageLabel.add(modifiedClass[i]);
      }
    }
    log('$angkaStrings');

    log('class yang berhasil terdeteksi adalah: $modifiedClass');
    for (var element in croppedImageLabel) {
      if (!totalLabel.keys.contains(element)) {
        totalLabel[element] = 1;
      } else {
        totalLabel[element] += 1;
      }
    }
    Map<String, dynamic> mutuTotal = getMutuBijiKopi(totalLabel);

    totalMutu = getTotalMutuBijiKopi(mutuTotal);
    mutu = getMutu(totalMutu!);

    // print(mutuTotal);

    log('Done');
    print(
        'list of croppedImage:  ${croppedImageList.length} and label is ${croppedImageLabel}');
    // mutuTotal = <String, dynamic>{};
    // mutuTotal.clear();
    update();

    return img.encodeJpg(imageInput);
  }

  Map<String, dynamic> getMutuBijiKopi(Map<String, dynamic> totalLabel) {
    final newTotalLabel = <String, dynamic>{};
    final multiplierMap = <String, double>{
      "hitam": 1.0,
      "hitam_pecah": 0.5,
      "hitam_sebagian": 0.5,
      "coklat": 0.25,
      "pecah": 0.5,
      "lubang_satu": 0.1,
      "lubang_lebih_dari_satu": 0.1,
      "biji_tanduk": 0.5,
      "kulit_tanduk_besar": 0.5,
      "kulit_tanduk_sedang": 0.25,
      "kulit_tanduk_kecil": 0.1,
      "gelondong": 1,
      "kulit_besar": 1,
      "kulit_sedang": 0.5,
      "kulit_kecil": 0.2,
      "muda": 0.2,
      "batu_besar": 5,
      "batu_sedang": 2,
      "batu_kecil": 1,
      "ranting_besar": 5,
      "ranting_sedang": 2,
      "ranting_kecil": 1,
      "tanah_besar": 5,
      "tanah_sedang": 2,
      "tanah_kecil": 1,
    };

    totalLabel.forEach((key, value) {
      if (multiplierMap.containsKey(key)) {
        double multiplier = multiplierMap[key]!;
        newTotalLabel[key] = value * multiplier;
      }
    });

    return newTotalLabel;
  }

  double getTotalMutuBijiKopi(Map<String, dynamic> data) {
    double sum = 0.0;
    data.forEach((key, value) {
      if (value is double) {
        sum += value;
      }
    });
    return sum;
  }

  String getMutu(double data) {
    if (data <= 11) {
      gradeTotal = "Mutu 1";
    } else if (data > 11 && data <= 25) {
      gradeTotal = "Mutu 2";
    } else if (data > 25 && data <= 44) {
      gradeTotal = "Mutu 3";
    } else if (data > 44 && data <= 60) {
      gradeTotal = "Mutu 4a";
    } else if (data > 60 && data <= 80) {
      gradeTotal = "Mutu 4b";
    } else if (data > 80 && data <= 150) {
      gradeTotal = "Mutu 5";
    } else if (data > 150 && data <= 225) {
      gradeTotal = "Mutu 6";
    }
    return gradeTotal;
  }

  List<List<Object>> _runInference(
    List<List<List<num>>> imageMatrix,
  ) {
    log('Running inference...');

    // Set input tensor [1, 300, 300, 3]
    final input = [imageMatrix];

    // Set output tensor
    // Locations: [1, 10, 4]
    // Classes: [1, 10],
    // Scores: [1, 10],
    // Number of detections: [1]
    // final output = {
    //   0: [List<num>.filled(10, 0)],
    //   1: [List<List<num>>.filled(10, List<num>.filled(4, 0))],
    //   2: [0.0],
    //   3: [List<num>.filled(10, 0)],
    // };
    final output = {
      0: [List<num>.filled(10, 0)],
      1: [List<List<num>>.filled(10, List<num>.filled(4, 0))],
      2: [0.0],
      3: [List<num>.filled(10, 0)],
    };

    _interpreter!.runForMultipleInputs([input], output);
    return output.values.toList();
  }

  List<List<List<double>>> parseNumToDouble(List<List<List<num>>> inputList) {
    // Use map to convert each element of the nested lists to double
    List<List<List<double>>> outputList = inputList.map((outerList) {
      return outerList.map((innerList) {
        return innerList.map((value) => value.toDouble()).toList();
      }).toList();
    }).toList();

    return outputList;
  }

  @override
  void onInit() async {
    super.onInit();
    _loadModel();
    _loadLabels();
    //ini jg diubah untuk tflite
    // await loadModel().then((value) => false);
    // await loadModel();
    // await detectObjects();
    // final images = File('assets/images/test1.jpg');
    // final imageBytes = (await rootBundle.load(images.path)).buffer;
    // img.Image? oriImage = img.decodeJpg(imageBytes.asUint8List());
    // img.Image resizedImage = img.copyResize(oriImage!, height: 320, width: 320);
    // final checkBytes = await imageToByteListUint8(resizedImage, 300);
    // var sum = 0;

    // for (var i = 0; i < checkBytes.length; i++) {
    //   sum += checkBytes[i];
    // }
    // log(sum);
  }
}
