import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'widgets/shadow_clipper.dart';

enum SeatStatus { available, reserved, selected }

class SelectSeatScreen extends StatefulWidget {
  const SelectSeatScreen({super.key});

  @override
  State<SelectSeatScreen> createState() => _SelectSeatScreenState();

  static Route route(RouteSettings routeSettings) {
    return MaterialPageRoute(
      builder: (_) => const SelectSeatScreen(),
    );
  }
}

class _SelectSeatScreenState extends State<SelectSeatScreen> {
  List<List<SeatStatus>> seats = [];
  Set<String> selectedSeats = {};

  @override
  void initState() {
    super.initState();
    _initializeSeats();
  }

  void _initializeSeats() {
    // Initialize 13 rows (A-M) with 13 seats each (1-13)
    for (int row = 0; row < 13; row++) {
      List<SeatStatus> seatRow = [];
      for (int col = 0; col < 13; col++) {
        // Create some reserved seats for demo
        if ((row == 5 && (col >= 6 && col <= 8)) || 
            (row == 6 && (col >= 6 && col <= 8)) ||
            (row == 7 && (col >= 6 && col <= 8))) {
          seatRow.add(SeatStatus.reserved);
        } else {
          seatRow.add(SeatStatus.available);
        }
      }
      seats.add(seatRow);
    }
  }

  void _toggleSeat(int row, int col) {
    if (row >= seats.length || col >= seats[row].length) return;
    if (seats[row][col] == SeatStatus.reserved) return;
    
    setState(() {
      String seatId = '${String.fromCharCode(65 + row)}${col + 1}';
      if (selectedSeats.contains(seatId)) {
        selectedSeats.remove(seatId);
        seats[row][col] = SeatStatus.available;
      } else {
        selectedSeats.add(seatId);
        seats[row][col] = SeatStatus.selected;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff000000),
      bottomNavigationBar: _buildBottomNavigationBar(),
      appBar: AppBar(
        backgroundColor: context.color.secondaryColor,
        title: Text(
          'Select Seat',
          style: TextStyle(
            color: context.color.textDefaultColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcons.arrow_left,
            height: 32,
            width: 32,
            colorFilter: ColorFilter.mode(
              context.color.textDefaultColor,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          // screen section
          SizedBox(
            height: 80, 
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned.fill(
                  top: 2, 
                  child: ClipPath(
                    clipper: ScreenShadowClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xffFF1E00).withValues(alpha: 0.21),
                            Color(0xff000000)
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color(0xffFF1E00),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffFF1E00).withValues(alpha: 0.25),
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Seat grid container (chỉ seat grid + column numbers)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Seat grid
                  Expanded(
                    child: seats.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xffFF1E00),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: List.generate(13, (rowIndex) {
                                if (rowIndex >= seats.length) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: _buildSeatRow(context, rowIndex),
                                  ),
                                );
                              }),
                            ),
                          ),
                  ),

                  const SizedBox(height: 20),

                  // Column numbers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 28),
                      ...List.generate(13, (index) {
                        return SizedBox(
                          width: (MediaQuery.of(context).size.width - 80) / 15,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: context.color.textDefaultColor,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                      const SizedBox(width: 28),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ✅ Legend tách riêng
          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('Available', Color(0xff1C1C1C)),
                _buildLegendItem('Reserved', Color(0xFFF6F5FA)),
                _buildLegendItem('Selected', Color(0xFFFF1E00)),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Color _getSeatColor(SeatStatus status) {
    switch (status) {
      case SeatStatus.available:
        return Color(0xff1C1C1C);
      case SeatStatus.reserved:
        return Color(0xFFF6F5FA);
      case SeatStatus.selected:
        return Color(0xffFF1E00);
    }
  }

  Color _getSeatTextColor(SeatStatus status) {
    switch (status) {
      case SeatStatus.available:
        return Color(0xffAAAAAA);
      case SeatStatus.reserved:
        return Color(0xff000000);
      case SeatStatus.selected:
        return Colors.white;
    }
  }

  Widget _buildSeatRow(BuildContext context, int rowIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Row label (A, B, C, etc.)
        Container(
          width: 20,
          child: Text(
            String.fromCharCode(65 + rowIndex),
            style: TextStyle(
              color: context.color.textDefaultColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(width: 8),
        // Seats
        ...List.generate(13, (colIndex) {
          if (colIndex >= seats[rowIndex].length) {
            return SizedBox(
              width: (MediaQuery.of(context).size.width - 80) / 15, 
              height: (MediaQuery.of(context).size.width - 80) / 15
            );
          }
          return GestureDetector(
            onTap: () => _toggleSeat(rowIndex, colIndex),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: (MediaQuery.of(context).size.width - 80) / 15,
              height: (MediaQuery.of(context).size.width - 80) / 15,
              margin: EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: _getSeatColor(seats[rowIndex][colIndex]),
                borderRadius: BorderRadius.circular(6),
                border: seats[rowIndex][colIndex] == SeatStatus.available 
                  ? Border.all(color: Color(0xff555555), width: 1)
                  : null,
                boxShadow: seats[rowIndex][colIndex] == SeatStatus.selected
                  ? [
                      BoxShadow(
                        color: Color(0xffFF1E00).withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
              ),
              child: Center(
                child: Text(
                  '${String.fromCharCode(65 + rowIndex)}${colIndex + 1}',
                  style: TextStyle(
                    color: _getSeatTextColor(seats[rowIndex][colIndex]),
                    fontSize: ((MediaQuery.of(context).size.width - 80) / 15) * 0.25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
        SizedBox(width: 8),
        // Row label again
        Container(
          width: 20,
          child: Text(
            String.fromCharCode(65 + rowIndex),
            style: TextStyle(
              color: context.color.textDefaultColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Color(0xffF2F2F2),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    int totalPrice = selectedSeats.length * 210000;
    
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xff1C1C1C),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
      child: Row(
        children: [
          // Total section
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    color: Color(0xffAAAAAA),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} VND',
                  style: TextStyle(
                    color: Color(0xffFF1E00),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(width: 16),
          
          // Buy ticket button
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffFF1E00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Buy ticket',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

