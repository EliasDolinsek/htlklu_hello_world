import 'package:ar_post/app/ar/ar_actions_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArControlsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 48.0),
        child: BlocBuilder<ArActionsBloc, ArActionsState>(
          builder: (context, state) {
            if (state.isPlaced || state.isCaptured) {
              return _buildPlacedOrCaptured(context, state);
            } else {
              return _buildNotPlaced(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildNotPlaced(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ArButton(
        iconData: Icons.push_pin,
        onPressed: () {
          context.read<ArActionsBloc>().add(const ArActionsEvent.place());
        },
      ),
    );
  }

  Widget _buildPlacedOrCaptured(BuildContext context, ArActionsState state) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildCapturedButtonContent(context, state),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 29.0,
              right: 55.0,
            ),
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 36,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                context
                    .read<ArActionsBloc>()
                    .add(const ArActionsEvent.release());
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCapturedButtonContent(
      BuildContext context, ArActionsState state) {
    if (state.isCaptured && state.image.isNone()) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 35.0),
        child: CircularProgressIndicator(),
      );
    } else {
      return ArButton(
        iconData: Icons.fiber_manual_record,
        onPressed: () {
          context.read<ArActionsBloc>().add(const ArActionsEvent.capture());
        },
      );
    }
  }
}

class ArButton extends StatelessWidget {
  final IconData iconData;
  final Function() onPressed;

  const ArButton({
    Key key,
    this.iconData,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 94,
          height: 94,
          child: CustomPaint(painter: CirclePaint(context)),
        ),
        SizedBox(
          width: 92,
          height: 92,
          child: IconButton(
            icon: Center(
              child: Icon(
                iconData,
                size: 38,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}

class CirclePaint extends CustomPainter {
  final BuildContext context;

  CirclePaint(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Theme.of(context).primaryColor
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
